//
//  SocketModel.m
//  ipadDemo
//
//  Created by 王旭 on 15/12/28.
//  Copyright © 2015年 王旭. All rights reserved.
//

#import "SocketModel.h"
#import "ODXSocket.h"


static SocketModel *singInstance = nil;

@interface SocketModel ()<ODXSocketDelegate>
@property ODXSocket *socket;
@end

@implementation SocketModel

- (instancetype)init{
    self = [super init];
    if (self) {
        _socket = [ODXSocket sharedSocket];
        _socket.delegate = self;
    }
    return self;
}

+ (id)sharedModel {
    
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

#pragma -mark socketDelegate

- (void)Unconnection {
    [_delegate UnconnectionTips];
}

- (void)remoteWithData:(NSData *)data {
    Byte *packet = (Byte *)[data bytes];
    unsigned short len = data.length;
    TKeyValue key = packet[11];
    if (key == kvCapture || key == kvManualCapture || key == kvQueryCar) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [self remoteAnalysisWithPacket:packet Len:len];
        });
    }
}

- (void)backgroundWithData:(NSData *)data {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        Byte *packet = (Byte *)[data bytes];
        unsigned short len = data.length;
        [self backgroundAnalysisWithPacket:packet Len:len];
    });
}

- (void)remoteAnalysisWithPacket:(uint8_t *)packet Len:(unsigned short)len {
    
//    int n = 12;
//    
//    NSMutableString *carNumberStr = [NSMutableString new];
//    for (int i = 0; i < 6; i++) {
//        [carNumberStr appendFormat:@"%c",(char)packet[n]];
//        n += 1;
//    }
//    
//    int carNo = packet[n];
//    n += 1;
    
    
}

- (void)backgroundAnalysisWithPacket:(uint8_t *)packet Len:(unsigned short)len {
    
    int n = 12;
    TTestState state = packet[n];
    NSString *tip;
    switch (state) {
        case tsInit:
            tip = @"设备正在初始化";
            break;
        case tsWaitVerifyIn:
            tip = @"请核验员至后台登入";
            break;
        case tsWaitLogIn:
            tip = @"等待检定员登入";
            break;
        case tsInputCarNo:
            tip = @"请获取车牌号";
            break;
        case tsPreMotorDevice:
            tip = @"欲初始化";
            break;
        case tsAskLogin:
            tip = @"请求登入";
            break;
        case tsAskCarNumplate:
            tip = @"请求车牌";
            break;
        case tsAskStartMotor:
            tip = @"请求启动马达";
            break;
        case tsWaitSaveSample:
            tip = @"保存采样";
            break;
        case tsInlineEditPar:
            tip = @"其他状态";
            break;
        case tsAskParList:
            tip = @"其他状态";
            break;
        case tsSaveParList:
            tip = @"其他状态";
            break;
        case tsWaitRunCmd:
            tip = @"等待启动";
            break;
        case tsRunning:
            tip = @"正在运行";
            break;
        case tsStop:
            tip = @"停止状态";
            break;
        case tsPreStop:
            tip = @"其他状态";
            break;
        case tsEditSample:
            tip = @"其他状态";
            break;
        case tsSendSample:
            tip = @"其他状态";
            break;
        case tsSaveSample:
            tip = @"其他状态";
            break;
        case tsAfterEditK:
            tip = @"其他状态";
            break;
        case tsAskEndChk:
            tip = @"其他状态";
            break;
        case tsSelectChkMode:
            tip = @"其他状态";
            break;
        case tsEndTest:
            tip = @"其他状态";
            break;
        case tsSetPar:
            tip = @"其他状态";
            break;
        case tSelfTest:
            tip = @"其他状态";
            break;
        case tsSysPar:
            tip = @"其他状态";
            break;
        case tsDirectDisp:
            tip = @"其他状态";
            break;
        case tsInputOffNo:
            tip = @"脱机状态";
            break;
            
        default:
            tip = @"未使用的状态";
            break;
    }
//    NSLog(@"status : %x",packet[n]);
    n += 1;
    
    BOOL hasCamera = packet[n];
//    NSLog(@"hasCamera : %x",packet[n]);
    n += 1;
    
    BOOL hasBg = packet[n];
    n += 1;
//    NSLog(@"hasBg : %x",hasBg);
    
    NSMutableString *heyanyuan = [NSMutableString new];
    if (hasBg && (state >= tsWaitLogIn)) {
        for (int i = 0; i < 6; i++) {
            [heyanyuan appendFormat:@"%c",(char)packet[n]];
            n += 1;
        }
    }else {
        NSString *s = @"-";
        [heyanyuan appendString:s];
        [heyanyuan appendString:s];
        [heyanyuan appendString:s];
        [heyanyuan appendString:s];
        [heyanyuan appendString:s];
        [heyanyuan appendString:s];
        n += 6;
    }
//    NSLog(@"heyan : %@",heyanyuan);
    
    NSMutableString *jiandingyuan = [NSMutableString new];
    if (hasBg && (state > tsWaitLogIn)) {
        for (int i = 0; i < 6; i++) {
            [jiandingyuan appendFormat:@"%c",(char)packet[n]];
            n += 1;
        }
    }else {
        NSString *s = @"-";
        [jiandingyuan appendString:s];
        [jiandingyuan appendString:s];
        [jiandingyuan appendString:s];
        [jiandingyuan appendString:s];
        [jiandingyuan appendString:s];
        [jiandingyuan appendString:s];
        n += 6;
    }
//    NSLog(@"jiand : %@",jiandingyuan);
    
    NSMutableString *carNumberStr = [NSMutableString new];
    for (int i = 0; i < 6; i++) {
        [carNumberStr appendFormat:@"%c",(char)packet[n]];
        n += 1;
    }
//    NSLog(@"car : %@",carNumberStr);
    
    unsigned int standard;
    uint8_t *p1 = (uint8_t *)&standard;
    for (int i = 0; i < 4; i++) {
        p1[3-i] = packet[n];
        n += 1;
    }
    NSString *standardString = [NSString stringWithFormat:@"%d",standard];
//    NSLog(@"standard : %@",standardString);
    
    float speed;
    uint8_t *p2 = (uint8_t *)&speed;
    for (int i = 0; i < 4; i++) {
        p2[3-i] = packet[n];
        n += 1;
    }
    NSString *speedStr = [NSString stringWithFormat:@"%.2f",speed];
//    NSLog(@"speed : %@",speedStr);
    
    NSMutableArray *sampleArr = [NSMutableArray new];
    unsigned int temp[6];
    for (int i = 0; i < 6; i++) {
        uint8_t *p = (uint8_t *)&temp[i];
        for (int j = 0; j < 4; j++) {
            p[3-j] = packet[n];
            n += 1;
        }
        if (temp[i] != 0) {
            NSString *s = [NSString stringWithFormat:@"%d",temp[i]];
            [sampleArr addObject:s];
        }
    }
    NSString *sampleStr = @"--";
    switch (sampleArr.count) {
        case 0:
            [sampleArr addObject:sampleStr];
            [sampleArr addObject:sampleStr];
            [sampleArr addObject:sampleStr];
            break;
        case 1:
            [sampleArr addObject:sampleStr];
            [sampleArr addObject:sampleStr];
            break;
        case 2:
            [sampleArr addObject:sampleStr];
            break;
            
        default:
            break;
    }
//    for (NSString *s in sampleArr) {
//        NSLog(@"sanmpleArr : %@",s);
//    }
    
    NSMutableArray *standardsArr = [NSMutableArray new];
    unsigned int temp1[6];
    for (int i = 0; i < 6; i++) {
        uint8_t *p = (uint8_t *)&temp1[i];
        for (int j = 0; j < 4; j++) {
            p[3-j] = packet[n];
            n += 1;
        }
        if (temp1[i] != 0) {
            NSString *s = [NSString stringWithFormat:@"%d",temp1[i]];
            [standardsArr addObject:s];
        }
    }
    NSString *standardsStr = @"--";
    switch (standardsArr.count) {
        case 0:
            [standardsArr addObject:standardsStr];
            [standardsArr addObject:standardsStr];
            [standardsArr addObject:standardsStr];
            break;
        case 1:
            [standardsArr addObject:standardsStr];
            [standardsArr addObject:standardsStr];
            break;
        case 2:
            [standardsArr addObject:standardsStr];
            break;
            
        default:
            break;
    }
//    for (NSString *s in standardsArr) {
//        NSLog(@"standardsArr : %@",s);
//    }
    
    _RemoteUpdateBlock(state,tip,hasCamera,hasBg,jiandingyuan);
    _updateBlock(state,tip,hasCamera,hasBg,heyanyuan,jiandingyuan,carNumberStr,sampleArr,standardsArr,standardString,speedStr);
}

//- (void)test {
//    NSDictionary *dic = [[NSMutableDictionary alloc] init];
//    NSString *chehao = @"苏B88888";
//    [dic setValue:chehao forKey:@"chehao"];
//    NSString *chexing = @"红旗";
//    [dic setValue:chexing forKey:@"chexing"];
//    NSString *jijiaqixinghao = @"JQS-3A";
//    [dic setValue:jijiaqixinghao forKey:@"jijiaqixinghao"];
//    NSString *jijiaqiqihao = @"1234";
//    [dic setValue:jijiaqiqihao forKey:@"jijiaqiqihao"];
//    NSString *jijiaqiKzhi = @"980";
//    [dic setValue:jijiaqiKzhi forKey:@"jijiaqiKzhi"];
//    NSString *luntaixinghao = @"185/60R14";
//    [dic setValue:luntaixinghao forKey:@"luntaixinghao"];
//    NSString *luntaiqiya = @"0.2MPa";
//    [dic setValue:luntaiqiya forKey:@"luntaiqiya"];
//    NSString *xiuzhengzhi = @"-1.5";
//    [dic setValue:xiuzhengzhi forKey:@"xiuzhengzhi"];
//    NSString *youxiaoqizhi = @"2006-10-11";
//    [dic setValue:youxiaoqizhi forKey:@"youxiaoqizhi"];
//    NSString *jianceriqi = @"2015-10-21";
//    [dic setValue:jianceriqi forKey:@"jianceriqi"];
//}

//获取数据后再执行test
//- (void)test {
//    NSDictionary *dic = [[NSMutableDictionary alloc] init];
//    NSString *chehao = @"苏B88888";
//    [dic setValue:chehao forKey:@"chehao"];
//    NSString *chexing = @"红旗";
//    [dic setValue:chexing forKey:@"chexing"];
//    NSString *jijiaqixinghao = @"JQS-3A";
//    [dic setValue:jijiaqixinghao forKey:@"jijiaqixinghao"];
//    NSString *jijiaqiqihao = @"1234";
//    [dic setValue:jijiaqiqihao forKey:@"jijiaqiqihao"];
//    NSString *jijiaqiKzhi = @"980";
//    [dic setValue:jijiaqiKzhi forKey:@"jijiaqiKzhi"];
//    NSString *luntaixinghao = @"185/60R14";
//    [dic setValue:luntaixinghao forKey:@"luntaixinghao"];
//    NSString *luntaiqiya = @"0.2MPa";
//    [dic setValue:luntaiqiya forKey:@"luntaiqiya"];
//    NSString *xiuzhengzhi = @"-1.5";
//    [dic setValue:xiuzhengzhi forKey:@"xiuzhengzhi"];
//    NSString *youxiaoqizhi = @"2006-10-11";
//    [dic setValue:youxiaoqizhi forKey:@"youxiaoqizhi"];
//    NSString *jianceriqi = @"2015-10-21";
//    [dic setValue:jianceriqi forKey:@"jianceriqi"];
//    
//    NSArray *cx = [[NSArray alloc]initWithObjects:@"红旗",@"桑塔纳",@"帕萨特",@"凯美瑞",@"阿斯顿马丁",@"布加迪威龙",nil];
//    [dic setValue:cx forKey:@"cx"];
//    NSArray *jjqxh = [[NSArray alloc]initWithObjects:@"JQS-3A",@"JQS-3B",@"JQS-3C",@"JQS-3D",nil];
//    [dic setValue:jjqxh forKey:@"jjqxh"];
//    NSArray *jjqqh = [[NSArray alloc]initWithObjects:@"1234",@"5678",@"2345",@"3456",@"6789",@"0000",nil];
//    [dic setValue:jjqqh forKey:@"jjqqh"];
//    NSArray *jjqkz = [[NSArray alloc]initWithObjects:@"980",@"970",@"960",@"950",@"940",@"930",nil];
//    [dic setValue:jjqkz forKey:@"jjqkz"];
//    NSArray *ltxh = [[NSArray alloc]initWithObjects:@"185/60R14",@"185/60R13",@"185/60R12",@"185/60R11",@"185/60R10",@"185/60R09",nil];
//    [dic setValue:ltxh forKey:@"ltxh"];
//    NSArray *ltqy = [[NSArray alloc]initWithObjects:@"0.2MPa",@"0.3MPa",@"0.4MPa",nil];
//    [dic setValue:ltqy forKey:@"ltqy"];
//    NSArray *xzz = [[NSArray alloc]initWithObjects:@"-1.6",@"-1.7",@"-1.8",nil];
//    [dic setValue:xzz forKey:@"xzz"];
//    
//    _modelBlock(dic);
//}

@end
