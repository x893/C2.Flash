#include <stdio.h>
#include <ctype.h>
#include "Serial.h"

uint16_t atox (char * s);
uint32_t atolx (char * s);

//-----------------------------------------------------------------------------
// atox
//-----------------------------------------------------------------------------
//
// Return Value : integer value of hex string pointed to by <s>
// Parameters   : <s> source string
//
// This is a coarse port from "_atoi.c" by Sandeep Dutta, from SDCC build
// ver 2.7.0.
//
// This function returns an integer which is the hexadecimal representation
// of the string pointed to by <s>.
//-----------------------------------------------------------------------------

uint16_t atox (char * s)
{
	register uint16_t rv = 0;
	register uint8_t hex_val;

	/* skip till we find either a hex digit */
	while (*s)
	{
		if (isxdigit (*s))
			break;
		s++;
	}

	while (*s && isxdigit(*s))
	{
		if ((*s >= '0') && (*s <= '9'))
		{
			hex_val = *s - '0';
		}
		else if ((*s >= 'a') && (*s <= 'f'))
		{
			hex_val = *s - ('a' - 10);
		}
		else
		{
			hex_val = 0;
		}
		rv = (rv * 16) + hex_val;
		s++;
	}

	return rv;
}

//-----------------------------------------------------------------------------
// atolx
//-----------------------------------------------------------------------------
//
// Return Value : 32-bit value of hex string pointed to by <s>
// Parameters   : <s> source string
//
// This is a coarse port from "_atoi.c" by Sandeep Dutta, from SDCC build
// ver 2.7.0.
//
// This function returns a long which is the hexadecimal representation
// of the string pointed to by <s>.
//-----------------------------------------------------------------------------

uint32_t atolx (char * s)
{
	uint32_t rv = 0;
	register uint8_t hex_val;

	/* skip till we find either a hex digit */
	while (*s)
	{
		if (isxdigit (*s))
		{
			break;
		}
		s++;
	}

	while (*s && isxdigit(*s))
	{
		if ((*s >= '0') && (*s <= '9'))
		{
			hex_val = *s - '0';
		}
		else if ((*s >= 'a') && (*s <= 'f'))
		{
			hex_val = *s - ('a' - 10);
		}
		else
		{
			hex_val = 0;
		}
		rv = (rv * 16) + hex_val;
		s++;
	}
	return rv;
}
