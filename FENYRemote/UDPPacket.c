//
//  UDPPacket.c
//  ipadDemo
//
//  Created by 王旭 on 15/12/7.
//  Copyright © 2015年 王旭. All rights reserved.
//

#include "UDPPacket.h"
#include "ODXFunctionCode.h"

unsigned short UDPPacket(unsigned char * const packet,unsigned char * const content,unsigned short const len,unsigned char const action,unsigned short ranNo,unsigned short count,unsigned short id) {
    
    uint8_t CMD = action;
    uint8_t IF = 0x48;
    uint8_t ranhigh = ranNo >> 8;
    uint8_t ranlow = ranNo & 0x00FF;
        
    uint8_t CWD[2] = {ranhigh,ranlow};
    uint8_t COUT = count;
    uint8_t MaterID[2] = {0x22,0xB8};
    
    uint8_t idHigh = id >> 8;
    uint8_t idLow = id & 0x00FF;
    uint8_t SalaverID[2] = {idHigh,idLow};
    
    uint8_t lenhigh = len >> 8;
    uint8_t lenlow = len & 0x00FF;
    
    uint8_t LEN[2] = {lenhigh,lenlow};
    
    packet[0] = CMD;
    packet[1] = IF;
    packet[2] = CWD[0];
    packet[3] = CWD[1];
    packet[4] = COUT;
    packet[5] = MaterID[0];
    packet[6] = MaterID[1];
    packet[7] = SalaverID[0];
    packet[8] = SalaverID[1];
    packet[9] = LEN[0];
    packet[10] = LEN[1];
    
    for (int i = 11; i < 11 + len; i++) {
        packet[i] = content[i - 11];
    }
    
    return 11 + len;
}

unsigned short  getCrc16(unsigned char * const ptr, unsigned short len )
{
    unsigned short crclen = Crc16(ptr, len);
    uint8_t crchigh = crclen >> 8;
    uint8_t crclow = crclen & 0x00FF;
    ptr[len] = crchigh;
    ptr[len + 1] = crclow;
    return len + 2;
}


