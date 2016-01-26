//
//  ODXFunctionCode.h
//  11.23C_Code
//
//  Created by 王旭 on 15/11/23.
//  Copyright © 2015年 王旭. All rights reserved.
//

#ifndef ODXFunctionCode_h
#define ODXFunctionCode_h

#include <stdio.h>
#include <string.h>

unsigned short makepacket(unsigned char * const pdst,unsigned char * const psrc,unsigned short const len);

unsigned short Unpacket(unsigned char * const pdst,unsigned char * const psrc,unsigned short const len);

unsigned short  Crc16( const unsigned char *ptr, unsigned short len );
#endif /* ODXFunctionCode_h */
