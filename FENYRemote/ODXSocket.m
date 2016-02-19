//
//  ODXSocket.m
//  ipadDemo
//
//  Created by 王旭 on 15/12/11.
//  Copyright © 2015年 王旭. All rights reserved.
//

#import "ODXSocket.h"
#include "ODXFunctionCode.h"
#include "UDPPacket.h"
#import <AudioToolbox/AudioToolbox.h>

static ODXSocket *singInstance = nil;

@interface ODXSocket (){
    dispatch_semaphore_t _semaphore;//定义一个信号量
}
@property (atomic) unsigned short ranNo;
@property (atomic) unsigned short count;
@property (atomic) BOOL received;

@end
@implementation ODXSocket

- (instancetype)init{
    self = [super init];
    if (self) {
        [self creatUdpSocket];
        _semaphore = dispatch_semaphore_create(1);
        [self sendDelegateThread];
    }
    return self;
}

+ (id)sharedSocket{
    
    @synchronized(self){
        static dispatch_once_t predicate;
        dispatch_once(&predicate, ^{
            singInstance = [[[self class] alloc] init];
        });
    }
    
    return singInstance;
}

+ (id)allocWithZone:(NSZone *)zone{
    if (singInstance == nil) {
        
        singInstance = [super allocWithZone:zone];
        
    }
    return singInstance;
}

- (id)copyWithZone:(NSZone *)zone{
    return singInstance;
}

- (void)creatUdpSocket{
    //创建一个后台队列 等待接收数据
    dispatch_queue_t dQueue = dispatch_queue_create("My socket queue", NULL);//第一个参数是该队列的名字,串行队列
    //1.实例化一个udp socket套接字对象
    //udpServerSocket需要用来接收数据
    UDPSocket = [[GCDAsyncUdpSocket alloc] initWithDelegate:self delegateQueue:dQueue socketQueue:nil];
    //2.服务器端来监听端口12345（等待端口12345的数据）
    [UDPSocket bindToPort:12345 error:nil];
    //3.接收一次消息（启动一个等待接收，且只接收一次）
    [UDPSocket receiveOnce:nil];
}

- (void)sendDelegateThread  {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        uint8_t CMD = 0x4a;
        uint8_t content[1];
        [self sendUDPWithCMD:CMD Content:content len:0 isBG:YES];
    });
}

- (void)sendRemoteThreadWithCMD:(uint8_t)cmd Content:(unsigned char * const)content len:(unsigned short)len  {
    [self sendUDPWithCMD:cmd Content:content len:len isBG:NO];
//    NSData *data = [[NSData alloc] initWithBytes:content length:len];
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        Byte *cont = (Byte *)[data bytes];
//        unsigned short len = data.length;
//        [self sendUDPWithCMD:cmd Content:cont len:len isBG:NO];
//    });
}

- (void)sendUDPWithCMD:(uint8_t)cmd Content:(unsigned char * const)content len:(unsigned short)len isBG:(BOOL)bg{
    dispatch_semaphore_wait(_semaphore, DISPATCH_TIME_FOREVER);
    _received = NO;
    _ranNo = rand() % 100;
    _count = 0;
    if (bg) {
        [self sendBgWithCMD:cmd Content:content len:len];
    }else {
        [self sendWithCMD:cmd Content:content len:len];
    }
}

- (void)sendBgWithCMD:(uint8_t)cmd Content:(unsigned char * const)content len:(unsigned short)len {
    uint8_t source[13 + sizeof(content)];
    unsigned short length = UDPPacket(source, content, len,cmd,_ranNo,_count,9999);
    unsigned short crc = Crc16(source, length);
    uint8_t crchigh = crc >> 8;
    uint8_t crclow = crc & 0x00FF;
    source[length] = crchigh;
    source[length + 1] = crclow;
    
    printf("\n^^^^^^^^^^^^^发发发发发^^^^^\n");
    for (int i = 0; i < length+2; i++) {
        printf("%x,",source[i]);
    }
    printf("\n^^^^^^^^^^^^^^^^^^^^^^^^^^\n");
    
    unsigned short n = (sizeof(source) / 7) + sizeof(source) + 3;
    uint8_t b[n];
    unsigned short en = makepacket(b, source, length + 2);
    NSData *data = [[NSData alloc] initWithBytes:b length:en];
    NSString *host = [[NSUserDefaults standardUserDefaults] objectForKey:@"LineIP"];
    uint16_t port = [[[NSUserDefaults standardUserDefaults] objectForKey:@"LinePort"] intValue];
    
    //开始发送
    //改函数只是启动一次发送 它本身不进行数据的发送, 而是让后台的线程慢慢的发送 也就是说这个函数调用完成后,数据并没有立刻发送,异步发送
    [UDPSocket sendData:data toHost:host port:port withTimeout:60 tag:100];
    
    //__block ODXSocket *bself = self;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
        [self sendBgAgain];
    });
}

- (void)sendBgAgain {
    if (_received) {
        [self sendDelegateThread];
    }else {
        [_delegate Unconnection];
        dispatch_semaphore_signal(_semaphore);
        [self sendDelegateThread];
    }
}

- (void)sendWithCMD:(uint8_t)cmd Content:(unsigned char * const)content len:(unsigned short)len  {
    uint8_t source[13 + sizeof(content)];
    unsigned short length = UDPPacket(source, content, len,cmd,_ranNo,_count,9999);
    unsigned short crc = Crc16(source, length);
    uint8_t crchigh = crc >> 8;
    uint8_t crclow = crc & 0x00FF;
    source[length] = crchigh;
    source[length + 1] = crclow;
    
    printf("\n^^^^^^^^^^^^^发发发发发^^^^^\n");
    for (int i = 0; i < length+2; i++) {
        printf("%x,",source[i]);
    }
    printf("\n^^^^^^^^^^^^^^^^^^^^^^^^^^\n");
    
    unsigned short n = (sizeof(source) / 7) + sizeof(source) + 3;
    uint8_t b[n];
    unsigned short en = makepacket(b, source, length + 2);
    NSData *data = [[NSData alloc] initWithBytes:b length:en];
    NSString *host = [[NSUserDefaults standardUserDefaults] objectForKey:@"LineIP"];
    uint16_t port = [[[NSUserDefaults standardUserDefaults] objectForKey:@"LinePort"] intValue];
    
    //开始发送
    //改函数只是启动一次发送 它本身不进行数据的发送, 而是让后台的线程慢慢的发送 也就是说这个函数调用完成后,数据并没有立刻发送,异步发送
    [UDPSocket sendData:data toHost:host port:port withTimeout:60 tag:100];
    
    //__block ODXSocket *bself = self;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
        [self sendAgainWithCMD:cmd Content:content len:len];
    });
}

- (void)sendAgainWithCMD:(uint8_t)cmd Content:(unsigned char * const)content len:(unsigned short)len {
    if (_received) {
        //NSLog(@"收到了");
    }else {
        if (_count > 1) {
            NSLog(@"发送三次都没收到回应");
            dispatch_semaphore_signal(_semaphore);
            AudioServicesPlaySystemSound(1106);
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
        }else {
            _count += 1;
            _ranNo += 1;
            [self sendWithCMD:cmd Content:content len:len];
        }
    }
}

#pragma mark -GCDAsyncUdpSocketDelegate
-(void)udpSocket:(GCDAsyncUdpSocket *)sock didSendDataWithTag:(long)tag{
    if (tag == 100) {
        //NSLog(@"表示标记为100的数据发送完成了");
    }
}
-(void)udpSocket:(GCDAsyncUdpSocket *)sock didNotSendDataWithTag:(long)tag dueToError:(NSError *)error{
    NSLog(@"标记为tag %ld的发送失败 失败原因 %@",tag, error);
}

-(void)udpSocket:(GCDAsyncUdpSocket *)sock didReceiveData:(NSData *)data fromAddress:(NSData *)address withFilterContext:(id)filterContext{
    
    Byte *byte = (Byte *)[data bytes];
    
    uint8_t packet[data.length];
    unsigned short de = Unpacket(packet, byte, data.length);
    
    unsigned short rand = ((packet[2] & 0x00FF) << 8) | packet[3];
    if (rand == _ranNo && packet[4] == _count) {
        _received = YES;
        NSData *packetData = [[NSData alloc] initWithBytes:packet length:de];
        switch (packet[0]) {
            case 0x3D:{
                NSLog(@"收到服务端的响应 ");
                printf("$$$$$$$收收收收收收$$$$$$$$\n");
                for (int i = 0; i < de; i++) {
                    printf("%x,",packet[i]);
                }
                printf("\n$$$$$$$$$$$$$$$$$$$$$$$$$\n");
            }
                break;
                
            case 0x4a:{
                printf("\n*****收到了后台响应*****\n");
                for (int i = 0; i < de; i++) {
                    printf("%x,",packet[i]);
                }
                printf("\n*******************\n");
                
                [_delegate backgroundWithData:packetData];
            }
                break;
                
            default:
                break;
        }
        
    }else {
        NSLog(@"error data !!!!");
    }
    // 继续来等待接收下一次消息
    [sock receiveOnce:nil];
    
    dispatch_semaphore_signal(_semaphore);
}

-(void)sendBackToHost:(NSString *)ip port:(uint16_t)port withMessage:(NSString *)s{
    
    
    //    NSString *msg = @"我再发送消息";
    //    NSData *data = [msg dataUsingEncoding:NSUTF8StringEncoding];
    //
    //    [sendUdpSocket sendData:data toHost:ip port:port withTimeout:60 tag:200];
}

-(void)dealloc{
    NSLog(@"%s",__func__ );
    [UDPSocket close];
    UDPSocket = nil;
}

@end
