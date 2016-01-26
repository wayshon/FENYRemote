//
//  ODXSocket.h
//  ipadDemo
//
//  Created by 王旭 on 15/12/11.
//  Copyright © 2015年 王旭. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GCDAsyncUdpSocket.h"


@protocol ODXSocketDelegate <NSObject>

@optional

- (void)Unconnection;
- (void)backgroundWithData:(NSData *)data;
- (void)remoteWithData:(NSData *)data;

@end

@interface ODXSocket : NSObject<GCDAsyncUdpSocketDelegate>{
    GCDAsyncUdpSocket *UDPSocket;
}

@property id <ODXSocketDelegate> delegate;

+ (ODXSocket *)sharedSocket;

- (void)sendRemoteThreadWithCMD:(uint8_t)cmd Content:(unsigned char * const)content len:(unsigned short)len;

@end
