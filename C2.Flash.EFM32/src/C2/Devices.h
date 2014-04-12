#ifndef __DEVICES_H__
#define __DEVICES_H__

#include <stdint.h>
#include <stdbool.h>

//-----------------------------------------------------------------------------
// Exported Structures, Unions, Enumerations, and Type Definitions
//-----------------------------------------------------------------------------

enum MEM_TYPE {
	FLASH = 0,
	OTP,
	ROM
};
enum IF_TYPE {
	JTAG = 0,
	C2
};
enum SECURITY_TYPE {
	JTAG_SECURITY = 0,
	C2_1,
	C2_2,
	C2_3
};

typedef char * INIT_STRING;

typedef struct DERIVATIVE_ENTRY
{
	uint16_t	DERIVATIVE_ID;		// Specific Derivative ID
		char *	DERIVATIVE_STRING;	// Specific Part number
		char *	FEATURES_STRING;	// String listing specific features
		char *	PACKAGE_STRING;		// String listing package info
	uint32_t	CODE_START;			// starting code address
	uint32_t	CODE_SIZE;			// size of code space
	uint32_t	WRITELOCKBYTEADDR;	// address of Write Lock Byte
	uint32_t	READLOCKBYTEADDR;	// address of Read Lock Byte
	uint32_t	CODE2_START;		// starting address of 2nd code bank
	uint32_t	CODE2_SIZE;			// size of code2 space
} DERIVATIVE_ENTRY;

typedef struct DEVICE_FAMILY
{
	uint16_t	DEVICE_ID;			// C2/JTAG family ID
		char *	FAMILY_STRING;		// name of device family
	uint8_t		MEM_TYPE;			// FLASH or OTP
	uint16_t	PAGE_SIZE;			// number of bytes per code page
	uint8_t		HAS_SFLE;			// TRUE if device has SFLE bit
	uint8_t		SECURITY_TYPE;		// Flash security type
	uint8_t		FPDAT;				// Flash Programming Data Register address
	const INIT_STRING * INIT_STRINGS;			// List of initialization commands
	const DERIVATIVE_ENTRY *DERIVATIVE_LIST;	// List of derivatives for this family
} DEVICE_FAMILY;

//-----------------------------------------------------------------------------
// Exported Global Variables
//-----------------------------------------------------------------------------

extern const DEVICE_FAMILY KNOWN_FAMILIES[];

extern uint8_t FAMILY_NUMBER;
extern uint8_t DERIVATIVE_NUMBER;

extern bool FAMILY_FOUND;
extern bool DERIVATIVE_FOUND;
extern bool DEVICE_HALTED;

#endif // DEVICES_H
