#ifndef __COMMON_H__
#define __COMMON_H__

#include <stdint.h>

// used with UU16
# define LSB 0
# define MSB 1

typedef union UU16
{
	uint16_t	U16;
	int16_t		S16;
	uint8_t		U8[2];
	int8_t		S8[2];
} UU16;

#endif
