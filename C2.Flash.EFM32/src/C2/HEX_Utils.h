#ifndef __HEX_UTILS__
#define __HEX_UTILS__

#include <stdint.h>
#include <stdbool.h>
#include "Common.h"

typedef struct
{
	uint8_t RECLEN;
	UU16 OFFSET;
	uint8_t RECTYP;
	uint8_t *Buf;
} HEX_RECORD;


#define HEX_RECLEN 32	// number of data bytes per generated HEX record

#define HEXREC_DAT 0	// Data Record
#define HEXREC_EOF 1	// End of File Record
#define HEXREC_EXA 2	// Extended Segment Address Record
#define HEXREC_SSA 3	// Start Segment Address Record
#define HEXREC_ELA 4	// Extended Linear Address Record
#define HEXREC_SLA 5	// Start Linear Address Record

uint8_t HEX_Encode (char *dest, HEX_RECORD *hexsrc, bool suppress);
uint8_t HEX_Decode (HEX_RECORD *hexdest, char *src);
uint8_t HEX2uc (char *src);
void uc2HEX (char *dest, uint8_t mychar);
void HEXSTR2BIN (char *dest, char *src, uint8_t *length);
void BIN2HEXSTR (char *dest, char *src, uint8_t  length);

#endif // __HEX_UTILS__
