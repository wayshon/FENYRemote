//
//  UDPPacket.h
//  ipadDemo
//
//  Created by 王旭 on 15/12/7.
//  Copyright © 2015年 王旭. All rights reserved.
//

#ifndef UDPPacket_h
#define UDPPacket_h

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>

unsigned short UDPPacket(unsigned char * const packet,unsigned char * const content,unsigned short const len,unsigned char const action,unsigned short ranNo,unsigned short count,unsigned short id);

unsigned short  getCrc16(unsigned char * const ptr, unsigned short len );

#endif /* UDPPacket_h */
