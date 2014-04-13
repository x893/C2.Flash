#ifndef __DEVICES_H__
#define __DEVICES_H__

#include <stdint.h>
#include <stdbool.h>

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
	const char * DERIVATIVE_STRING;	// Specific Part number
	const char * FEATURES_STRING;	// String listing specific features
	const char * PACKAGE_STRING;		// String listing package info
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
	const char * FAMILY_STRING;		// name of device family
	uint8_t		MEM_TYPE;			// FLASH or OTP
	uint16_t	PAGE_SIZE;			// number of bytes per code page
	uint8_t		HAS_SFLE;			// TRUE if device has SFLE bit
	uint8_t		SECURITY_TYPE;		// Flash security type
	uint8_t		FPDAT;				// Flash Programming Data Register address
	const INIT_STRING *		InitStrings;		// List of initialization commands
	const DERIVATIVE_ENTRY *DerivativeList;	// List of derivatives for this family
} DEVICE_FAMILY;

extern const DEVICE_FAMILY KnownFamilies[];

extern uint8_t FamilyNumber;
extern uint8_t DerivativeNumber;

extern bool FamilyFound;
extern bool DerivativeFound;
extern bool DeviceHalted;

#endif // DEVICES_H
