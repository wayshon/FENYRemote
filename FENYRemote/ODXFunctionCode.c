//
//  ODXFunctionCode.c
//  11.23C_Code
//
//  Created by 王旭 on 15/11/23.
//  Copyright © 2015年 王旭. All rights reserved.
//

#include "ODXFunctionCode.h"
unsigned short Unpacket(unsigned char * const pdst,unsigned char * const psrc,unsigned short const len)
{
    unsigned short i,k = 0;
    unsigned char uctmp = 0,wdata = 0;
    unsigned short result = 0;
    for (i = 0; i < len; i++)
    {
        uctmp = psrc[i];
        switch (uctmp) {
            case 0x82u:
                k = 0;
                break;
            case 0x83u:
                result = k / 8;
                return result;
                break;
            default:
                
                switch (k % 8)
                {
                    case 0:
                        wdata = (uctmp << 1);
                        break;
                    case 1:
                        wdata |= uctmp;
                        pdst[k / 8] = wdata;
                        result += 1;
                        wdata = 0;
                        break;
                    case 2:
                        wdata |= (uctmp >> 1);
                        pdst[k / 8] = wdata;
                        result += 1;
                        wdata = (uctmp << 7);
                        break;
                    case 3:
                        wdata |= (uctmp >> 2);
                        pdst[k / 8] = wdata;
                        result += 1;
                        wdata = (uctmp << 6);
                        break;
                    case 4:
                        wdata |= (uctmp >> 3);
                        pdst[k / 8] = wdata;
                        result += 1;
                        wdata = (uctmp << 5);
                        break;
                    case 5:
                        wdata |= (uctmp >> 4);
                        pdst[k / 8] = wdata;
                        result += 1;
                        wdata = (uctmp << 4);
                        break;
                    case 6:
                        wdata |= (uctmp >> 5);
                        pdst[k / 8] = wdata;
                        result += 1;
                        wdata = (uctmp << 3);
                        break;
                    default:
                        wdata |= (uctmp >> 6);
                        pdst[k / 8] = wdata;
                        result += 1;
                        wdata = (uctmp << 2);
                        break;
                }
                k += 7;
                break;
        }
    }
    return result;
}

unsigned short makepacket(unsigned char * const pdst,unsigned char * const psrc,unsigned short const len){
    unsigned short i,remain = 0,j = 1;
    pdst[0] = 0x82;
    unsigned char uctmp = 0,wdata = 0;
    for (i = 0; i < len; i++)
    {
        uctmp = psrc[i];
        switch (remain)
        {
            case 0:
                wdata = ((uctmp & 0xfeu) >> 1);
                pdst[j++] = wdata;
                wdata = ((uctmp & 0x01u) << 6);
                remain = 1;
                break;
            case 1:
                wdata |= ((uctmp & 0xfcu) >> 2);
                pdst[j++] = wdata;
                wdata = ((uctmp & 0x03u) << 5);
                remain = 2;
                break;
            case 2:
                wdata |= ((uctmp & 0xf8u) >> 3);
                pdst[j++] = wdata;
                wdata = ((uctmp & 0x07u) << 4);
                remain = 3;
                break;
            case 3:
                wdata |= ((uctmp & 0xf0u) >> 4);
                pdst[j++] = wdata;
                wdata = ((uctmp & 0x0fu) << 3);
                remain = 4;
                break;
            case 4:
                wdata |= ((uctmp & 0xe0u) >> 5);
                pdst[j++] = wdata;
                wdata = ((uctmp & 0x1fu) << 2);
                remain = 5;
                break;
            case 5:
                wdata |= ((uctmp & 0xc0u) >> 6);
                pdst[j++] = wdata;
                wdata = ((uctmp & 0x3fu) << 1);
                remain = 6;
                break;
            default:
                wdata |= ((uctmp & 0x80u) >> 7);
                pdst[j++] = wdata;
                wdata = ((uctmp & 0x7fu) << 0);
                pdst[j++] = wdata;
                remain = 0;
                break;
        }
    }
    if (remain > 0)
    {
        pdst[j++] = wdata;
    }
    pdst[j++] = 0x83;
    return j;
}

unsigned short  Crc16( const unsigned char *ptr, unsigned short len )
{
    unsigned char i,ch;
    unsigned short crc16 = 0x445au;
    while(len != 0)
    {
        ch = *ptr++;
        for (i = 0; i < 8; i++)
        {
            if(crc16 & 0x8000u)
            {
                crc16 <<= 1;
                if (ch & 0x80u)
                {
                    crc16 |= 1;
                }
                crc16 ^= 0x1021u;
            }
            else
            {
                crc16 <<= 1;
                if (ch & 0x80u)
                {
                    crc16 |= 1;
                }
            }
            ch <<= 1;
        }
        len--;
    }
    return crc16;
}

