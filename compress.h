#ifndef COMPRESS_H
#define COMPRESS_H

#define C_BIT_MASK      0x01
#define H_BIT_MASK      0x02

#define DEFAULT_C       6
#define DEFAULT_PIXEL   0
#define DEFAULT_HV      1
/**
 *
 */
enum EncSpecialChar {
    /* markups */
    EncEscape=0xff,
    EncStartOfLine=0xfe,
    EncNewFrame=0xfd,
    NewBits=0xfc,
    /* instead of #DEFINE */
 //   C_BIT_MASK = 0x01,
 //   H_BIT_MASK = 0x02
};
/**
 * 
 *
 */
void cmpr_encode(streaming chanend c_in, streaming chanend c_out);
void cmpr_decode(streaming chanend c_in, streaming chanend c_out);

#endif
