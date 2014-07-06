#include <stdio.h>
#include <string.h>
#include <stdlib.h>

#include "Platform.h"

#include "Devices.h"
#include "Errors.h"
#include "Timing.h"
#include "Serial.h"
#include "HEX_Utils.h"

#include "C2_Utils.h"
#include "C2_Flash.h"

#define VERSION "0.01"

typedef struct
{
	uint8_t		number;		// unique command number
	const char *name;		// unique command identifier string
	uint8_t		name_size;	// size of name above
	const char *usage;		// usage string
	const char *menu;		// menu string
	bool		display;	// flag to display command or not
	bool		need_discover;
} COMMAND;


const COMMAND Commands[] =
{
	{ 0, "da      ",	2, "da               ", "Device Autodetect",	true, false	},
	{ 1, "?       ",	1, "?                ", "Print Menu",			true, false	},
	{ 2, "wms     ",	3, "wms <16d>        ", "Wait ms",				true, false	},
	{ 3, "wus     ",	3, "wus <16d>        ", "Wait us",				true, false	},
	{ 4, "start   ",	5, "start            ", "Start Stopwatch",		true, false	},
	{ 5, "stop    ",	4, "stop             ", "Stop Stopwatch",		true, false	},
	{ 6, "stoms   ",	5, "stoms <16d>      ", "Set Timeout ms",		true, false	},
	{ 7, "stous   ",	5, "stous <16d>      ", "Set Timeout us",		true, false	},
	{ 8, "pi      ",	2, "pi               ", "Pin init",				true, false	},
	{ 9, "c2rst   ",	5, "c2rst            ", "C2 Reset",				true, false	},
	{10, "wa      ",	2, "wa <8h>          ", "C2 Write Address",		true, false	},
	{11, "ra      ",	2, "ra               ", "C2 Read Address",		true, false	},
	{12, "wd      ",	2, "wd <8h>          ", "C2 Write Data",		true, false	},
	{13, "rd      ",	2, "rd               ", "C2 Read Data",			true, false	},
	{14, "c2halt  ",	6, "c2halt           ", "C2 Reset and Halt",	true, false	},
	{15, "c2dev   ",	5, "c2dev            ", "C2 Get Device ID",		true, false	},
	{16, "c2rev   ",	5, "c2rev            ", "C2 Get Revision ID",	true, false	},
	{17, "c2rsfr  ",	6, "c2rsfr <8h>      ", "C2 Read SFR",			true, false	},
	{18, "c2wsfr  ",	6, "c2wsfr <8h> <8h> ", "C2 Write SFR",			true, false	},
	{19, "c2rd    ",	4, "c2rd <8h>        ", "C2 Read Direct",		true, true	},
	{20, "c2wd    ",	4, "c2wd <8h> <8h>   ", "C2 Write Direct",		true, true	},
	{21, "c2ri    ",	4, "c2ri <8h>        ", "C2 Read Indirect",		true, true	},
	{22, "c2wi    ",	4, "c2wi <8h> <8h>   ", "C2 Write Indirect",	true, true	},
	{23, "c2d     ",	3, "c2d              ", "C2 Discover",			true, false	},
	{24, "init    ",	4, "init             ", "Run Init String",		true, true	},
	{25, "c2fr    ",	4, "c2fr <32h> <16d> ", "C2 Flash Read <start addr> <length>",		true, true	},
	{26, "c2or    ",	4, "c2or <32h> <16d> ", "C2 OTP Read <start addr> <length>",		true, true	},
	{27, "c2fw    ",	4, "c2fw <32h> <hex> ", "C2 Flash Write <start addr> <hex string>",	true, true	},
	{28, "c2ow    ",	4, "c2ow <32h> <hex> ", "C2 OTP Write <start addr> <hex string>",	true, true	},
	{29, "c2fpe   ",	5, "c2fpe <32h>      ", "C2 Page Erase <address in page to erase>", true, true	},
	{30, "c2fde   ",	5, "c2fde            ", "C2 Device Erase",							true, true	},
	{31, "c2fbc   ",	5, "c2fbc            ", "C2 Flash Blank Check",						true, true	},
	{32, "c2obc   ",	5, "c2obc            ", "C2 OTP Blank Check",						true, true	},
	{33, "c2glb   ",	5, "c2glb            ", "C2 Get Lock Byte value",					true, true	},
	{34, "wt2h    ",	4, "wt2h             ", "Write Target to HEX",						true, true	},
	{35, "rsfrs   ",	5, "rsfrs            ", "Read SFRs",								true, true	},
	{36, "wh2t    ",	5, "wh2t             ", "Write HEX to Target",						true, true	},
	{00, NULL,			0, NULL,				NULL,	false, false	},
	{99, "",			0, "Error            ", "",		true,  false	}
};

const INIT_STRING * CommandsList;
char Command[256];
char HexDest[256];
uint8_t BinDest[32];
HEX_RECORD HexRecord;

//-----------------------------------------------------------------------------
// Display_Menu
//-----------------------------------------------------------------------------
//
// Return Value : None
// Parameters   : None
//
// Prints the command menu to stdio.
//
//-----------------------------------------------------------------------------
void Display_Menu (void)
{
	const COMMAND *ctptr = Commands;
	printf("\n8-bit Device Programmer ver %s\n", VERSION);
	printf(" #  Command\tUsage         \t\tDescription\n");
	printf("--- -------\t-----         \t\t-----------\n");
	while (ctptr->name != NULL)
	{
		if (ctptr->display)
		{
			printf("%02u: ", ctptr->number);
			printf("%s", ctptr->name);
			printf("\t%s", ctptr->usage);
			printf("\t%s", ctptr->menu);
			printf("\n");
		}
		ctptr++;
	}
}

//-----------------------------------------------------------------------------
// GetString
//-----------------------------------------------------------------------------
//
// Return Value : Pointer to string containing buffer read from UART.
// Parameters   : <buf> to store string; maximum <n>umber of characters to
//                read; <n> must be 2 or greater.
//
// This function returns a string of maximum length <n>.
//-----------------------------------------------------------------------------
int GetString()
{
	char c;
	int len = 0;
	char *buffer = Command;
	int max_length = sizeof(Command) - 1;

	SetLedPeriod(900, 100);
	printf("READY\r\n> ");

	while(1)
	{
		c = GETCHAR();
		if (c != '\0')
		{
			if (c == '\b' || c == 0x7F)
			{
				if (len != 0)
				{
					PUTCHAR(c);
					--len;
					--buffer;
				}
			}
			else if (c == '\r' || c == '\n')
			{
				SetLedPeriod(0, 0);
				PUTCHAR('\n');
				if (max_length == 0)
				{
					printf("Result: FF COMMAND_TOO_LONG\n");
					buffer = Command;
				}
				*buffer = '\0';
				return len;
			}
			else if (len != max_length)
			{
				PUTCHAR(c);
				*buffer++ = c;
				len++;
			}
			else
			{
				max_length = 0;
				len = 0;
			}
		}
	}
}

//-----------------------------------------------------------------------------
// OP_Write_TARGET2HEX
//-----------------------------------------------------------------------------
//
// Return Value : Error code
// Parameters   : none
//
// This function reads the entire code contents of a device and outputs
// HEX records to the UART.
//
// To do: -- add SFLE support
//        -- add support for variable starting address and length
//
//-----------------------------------------------------------------------------
uint8_t OP_Write_TARGET2HEX (void)
{
	uint8_t reclen;
	uint8_t i;
	bool blank;
	uint8_t result = NO_ERROR;
	uint8_t mem_type = KnownFamilies[FamilyNumber].MEM_TYPE;
	uint32_t length = KnownFamilies[FamilyNumber].DerivativeList[DerivativeNumber].CODE_SIZE;
	uint32_t address = 0;

	while (length != 0)
	{
		// calculate size of hex record
		if (length > HEX_RECLEN)
		{
			reclen = HEX_RECLEN;
			length = length - reclen;
		}
		else
		{
			reclen = length;
			length = 0;
		}

		if (mem_type == MEM_FLASH)
		{
			// read the target buffer
			if (NO_ERROR != (result = C2_FLASH_Read (BinDest, address, reclen)))
				return result;
		}
		else if (mem_type == MEM_OTP)
		{
			// read the target buffer
			if (NO_ERROR != (result = C2_OTP_Read (BinDest, address, reclen)))
				return result;
		}

		// at this point, ibuf contains the contents of the desired HEX record.
		// Populate the record.
		HexRecord.Buf = BinDest;
		HexRecord.RECLEN = reclen;
		HexRecord.RECTYP = HEXREC_DAT;
		HexRecord.OFFSET.U16 = address;

		// update address
		address = address + reclen;

		// Suppress 0xFF records
		// check for 0xFF's
		blank = true;
		for (i = 0; i < reclen; i++)
		{
			if (BinDest[i] != 0xFF)
			{
				blank = false;
				break;
			}
		}

		if (blank == false)
		{
			HEX_Encode (HexDest, &HexRecord, 1);
			printf ("%s\n", HexDest);
		}
	}

	// print ending record
	printf (":00000001FF\n");

	return result;
}

//-----------------------------------------------------------------------------
// Get pointer to next word
//-----------------------------------------------------------------------------
//
// Return Value : Pointer to next word
// Parameters   : Pointer to input string
//
//-----------------------------------------------------------------------------
char * GetNextWord(register char * src)
{
	register char ch;
	register bool space = true;
	while ((ch = *src) != '\0')
	{
		if (space)
		{
			if (ch == ' ')
				space = false;
		}
		else
		{
			if (ch != ' ')
				break;
		}
		src++;
	}
	return src;
}

uint8_t CheckEmpty(register const char *src)
{
	if (src == NULL || *src == '\0')
		return INVALID_PARAMS;
	return NO_ERROR;
}
//-----------------------------------------------------------------------------
// Command_Decode
//-----------------------------------------------------------------------------
//
// Return Value : Error code
// Parameters   : Pointer to input string
//
// Parses the command string and calls the appropriate functions.
//
//-----------------------------------------------------------------------------
uint8_t CommandDecode(char * instr)
{
	char * cp;						// character pointer
	const DEVICE_FAMILY *dfptr;		// pointer to current device family
	const DERIVATIVE_ENTRY *deptr;	// pointer to current derivative
	uint8_t command_number = 99;	// number of command encoded in 'instr'
	uint8_t result = INVALID_COMMAND;

	printf("Command: %s\n", instr);
	command_number = 0xFF;
	if (instr[0] >= '0' && instr[0] <= '9')
	{
		// if first char is a digit, then interpret it as a command number
		command_number = atoi (instr);
	}

	{
		// interpret command as a string and find command number
		// or find command by command_number
		const COMMAND *ctptr = Commands;
		while (ctptr->name != NULL)
		{
			if (command_number != 0xFF)
			{
				if (ctptr->number == command_number)
					break;
			}
			else if (strncmp (instr, ctptr->name, ctptr->name_size) == 0)
			{	// we've found the command, so record its number and exit
				command_number = ctptr->number;
				break;
			}
			ctptr++;
		}
		if (ctptr->name != NULL)
		{
			if (ctptr->need_discover && !FamilyFound)
			{
				result = DEVICE_UNDISCOVERED;
				command_number = 0xFE;	// Unknown command
			}
		}
		else
			command_number = 0xFF;	// Unknown command
	}

	// Now we have a command number, so act on it.
	switch (command_number)
	{
		case 0:	// Device Autodetect
		{
			uint8_t deviceId = 0xFF;		// initialize device and derivative
			uint8_t revisionId = 0xFF;
			uint8_t derivativeId = 0xFF;	// id's to invalid selections

			printf("Device Autodetect\n");
			Start_Stopwatch();
			if (NO_ERROR == (result = C2_Halt ())
			&&	NO_ERROR == (result = C2_Discover (&deviceId, &revisionId, &derivativeId))
				)
			{
				CommandsList = KnownFamilies[FamilyNumber].InitStrings;
			}
			Stop_Stopwatch();
			printf("Device ID     : %02X\n", deviceId);
			printf("Revision ID   : %02X\n", revisionId);
			printf("Derivative ID : %02X\n", derivativeId);
			break;
		}
		case 1:	// Print Menu
		{
			printf("? stub\n");
			Start_Stopwatch();
			Display_Menu();
			Stop_Stopwatch();
			result = NO_ERROR;
			break;
		}
		case 2:	// Wait ms
		{
			uint16_t wait_time;
			cp = GetNextWord(instr);
			if (NO_ERROR == (result = CheckEmpty(cp)))
			{
				wait_time = atoi (cp);
				printf("Waiting %d ms\n", wait_time);
				Start_Stopwatch();
				Wait_ms (wait_time);
				Stop_Stopwatch();
				printf("Stopwatch_ms is %u\n", Stopwatch_ms);
				result = NO_ERROR;
			}
			break;
		}
		case 3:	// Wait us
		{
			uint16_t wait_time;
			cp = GetNextWord(instr);
			if (NO_ERROR == (result = CheckEmpty(cp)))
			{
				wait_time = atoi (cp);

				printf("Waiting %d us\n", wait_time);
				Start_Stopwatch();
				Wait_us (wait_time);
				Stop_Stopwatch();
				printf("Stopwatch_us is %u\n", Stopwatch_us);

				result = NO_ERROR;
			}
			break;
		}
		case 4:	// Start Stopwatch
		{
			printf("Start Stopwatch\n");
			result = Start_Stopwatch();
			break;
		}
		case 5:	// Stop Stopwatch
		{
			printf("Stop Stopwatch\n");
			result = Stop_Stopwatch();
			printf("Stopwatch_ms is %u\n", Stopwatch_ms);
			printf("Stopwatch_us is %u\n", Stopwatch_us);
			break;
		}
		case 6:	// Set Timeout ms
		{
			uint16_t wait_time;
			printf("Set Timeout ms:\n");
			cp = GetNextWord(instr);
			if (NO_ERROR == (result = CheckEmpty(cp)))
			{
				wait_time = atoi (cp);

				printf("Timing out for %d ms\n", wait_time);
				Start_Stopwatch();
				SetTimeout_ms (wait_time);
				SetTimeout_us (1);
				while (!IsDoneTimeout_ms())
					;
				Stop_Stopwatch();
				printf("Stopwatch_ms is %u\n", Stopwatch_ms);
				result = NO_ERROR;
			}
			break;
		}
		case 7:	// Set Timeout us
		{
			uint16_t wait_time;
			printf("Set Timeout us\n");
			cp = GetNextWord(instr);
			if (NO_ERROR == (result = CheckEmpty(cp)))
			{
				wait_time = atoi(cp);

				printf("Timing out for %d us\n", wait_time);
				Start_Stopwatch();
				SetTimeout_us(wait_time);
				while (!IsDoneTimeout_us())
					;
				Stop_Stopwatch();
				printf("Stopwatch_us is %u\n", Stopwatch_us);

				result = NO_ERROR;
			}
			break;
		}
		case 8:		// Pin init
		{
			printf("Pin Init\n");
			result = Pin_Init();
			break;
		}
		case 9:		// C2 Reset
		{
			printf("C2 Reset\n");
			result = C2_Reset();
			break;
		}
		case 10:	// C2 Write Address
		{
			uint16_t addr;
			cp = GetNextWord(instr);
			if (NO_ERROR == (result = CheckEmpty(cp)))
			{
				addr = atox (cp);

				printf("C2 Write Address: %02X\n", addr);
				Start_Stopwatch();
				result = C2_WriteAR(addr);
				Stop_Stopwatch();
			}
			break;
		}
		case 11:	// C2 Read Address
		{
			Start_Stopwatch();
			result = C2_ReadAR();
			Stop_Stopwatch();
			printf("C2 Read Address: %02X\n", (uint16_t) C2_AR);
			break;
		}
		case 12:	// C2 Write Data
		{
			uint8_t data;
			cp = GetNextWord(instr);
			if (NO_ERROR == (result = CheckEmpty(cp)))
			{
				data = atox (cp);

				printf("C2 Write Data: %02X\n", (uint16_t) data);
				Start_Stopwatch ();
				result = C2_WriteDR (data, C2_WRITE_DR_TIMEOUT_US);
				Stop_Stopwatch ();
			}
			break;
		}
		case 13:	// C2 Read Data
		{
			Start_Stopwatch ();
			result = C2_ReadDR (C2_READ_DR_TIMEOUT_US);
			Stop_Stopwatch ();
			printf("C2 Read Data: %02X\n", (uint16_t) C2_DR);
			break;
		}
		case 14:	// C2 Reset and Halt
		{
			printf("C2 Reset and Halt\n");
			result = C2_Halt ();
			break;
		}
		case 15:	// C2 Get Device ID
		{
			uint8_t devId;

			printf("C2 Get Device ID\n");
			Start_Stopwatch ();
			result = C2_GetDevID (&devId);
			Stop_Stopwatch ();
			printf("Device ID is %u, 0x%04X\n", devId, devId);
			break;
		}
		case 16:	// C2 Get Revision ID
		{
			uint8_t revid;
			printf("C2 Get Revision ID\n");
			Start_Stopwatch ();
			result = C2_GetRevID (&revid);
			Stop_Stopwatch ();
			printf("Revision ID is %u, 0x%04X\n", revid, revid);
			break;
		}
		case 17:	// C2 Read SFR
		{
			uint8_t sfr_value, sfr_address;
			cp = GetNextWord(instr);
			if (NO_ERROR == (result = CheckEmpty(cp)))
			{
				sfr_address = atox (cp);

				Start_Stopwatch ();
				result = C2_ReadSFR (sfr_address, &sfr_value);
				Stop_Stopwatch ();
				printf("C2 Read SFR(%02X) %02X\n", (uint16_t) sfr_address, (uint16_t) sfr_value);
			}
			break;
		}
		case 18:	// C2 Write SFR
		{
			uint8_t sfr_address, sfr_value;

			cp = GetNextWord(instr);
			if (NO_ERROR == (result = CheckEmpty(cp)))
			{
				sfr_address = atox (cp);
				cp = GetNextWord(cp);
				if (NO_ERROR == (result = CheckEmpty(cp)))
				{
					sfr_value = atox (cp);

					printf("C2 Write %02X to SFR(%02X)\n", (uint16_t) sfr_value, (uint16_t) sfr_address);
					Start_Stopwatch ();
					result = C2_WriteSFR (sfr_address, sfr_value);
					Stop_Stopwatch ();
				}
			}
			break;
		}
		case 19:	// C2 Read Direct
		{
			uint8_t sfr_value, sfr_address;
			cp = GetNextWord(instr);
			if (NO_ERROR == (result = CheckEmpty(cp)))
			{
				sfr_address = atox (cp);

				Start_Stopwatch ();
				result = C2_ReadDirect (sfr_address, &sfr_value, C2_DIRECT);
				Stop_Stopwatch ();
				printf("C2 Read Direct(%02X) %02X\n", (uint16_t) sfr_address, (uint16_t) sfr_value);
			}
			break;
		}
		case 20:	// C2 Write Direct <address> <value>
		{
			uint8_t sfr_address, sfr_value;

			cp = GetNextWord(instr);
			if (NO_ERROR == (result = CheckEmpty(cp)))
			{
				sfr_address = atox (cp);
				cp = GetNextWord(cp);
				if (NO_ERROR == (result = CheckEmpty(cp)))
				{
					sfr_value = atox (cp);

					printf("C2 Write %02x to Direct(%02X)\n", (uint16_t) sfr_value, (uint16_t) sfr_address);
					Start_Stopwatch ();
					result = C2_WriteDirect (sfr_address, sfr_value, C2_DIRECT);
					Stop_Stopwatch ();
				}
			}
			break;
		}
		case 21:	// C2 Read Indirect
		{
			uint8_t sfr_value, sfr_address;
			
			cp = GetNextWord(instr);
			if (NO_ERROR == (result = CheckEmpty(cp)))
			{
				sfr_address = atox (cp);

				Start_Stopwatch ();
				result = C2_ReadDirect (sfr_address, &sfr_value, C2_INDIRECT);
				Stop_Stopwatch ();
				printf("C2 Read Indirect(%02X) %02X\n", (uint16_t) sfr_address, (uint16_t) sfr_value);
			}
			break;
		}
		case 22:	// C2 Write Indirect
		{
			uint8_t sfr_address;
			uint8_t sfr_value;

			cp = GetNextWord(instr);
			if (NO_ERROR == (result = CheckEmpty(cp)))
			{
				sfr_address = atox (cp);
				cp = GetNextWord(cp);
				if (NO_ERROR == (result = CheckEmpty(cp)))
				{
					sfr_value = atox (cp);

					printf("C2 Write %02x to Indirect(%02X)\n", (uint16_t) sfr_value, (uint16_t) sfr_address);
					Start_Stopwatch ();
					result = C2_WriteDirect (sfr_address, sfr_value, C2_INDIRECT);
					Stop_Stopwatch ();
				}
			}
			break;
		}
		case 23:	// C2 Discover
		{
			uint8_t j, deviceId, revisionId, derivativeId;

			printf("C2 Discover\n");
			Start_Stopwatch ();
			result = C2_Discover (&deviceId, &revisionId, &derivativeId);
			Stop_Stopwatch ();

			if (result != NO_ERROR)
				break;

			dfptr = &(KnownFamilies[FamilyNumber]);
			deptr = &(KnownFamilies[FamilyNumber].DerivativeList[DerivativeNumber]);

			printf("Family Information:\n");
			printf("Device ID: 0x%04X\n", dfptr->DEVICE_ID);
			printf("Family string: %s\n", dfptr->FAMILY_STRING);
			printf("Mem Type: %u\n", (uint16_t) dfptr->MEM_TYPE);
			printf("Page Size: %u\n", dfptr->PAGE_SIZE);
			printf("Has SFLE: %u\n", (uint16_t) dfptr->HAS_SFLE);
			printf("Security Type: %u\n", (uint16_t) dfptr->SECURITY_TYPE);
			printf("FPDAT address: 0x%02X\n", (uint16_t) dfptr->FPDAT);
			printf("Device ID: 0x%04X\n", dfptr->DEVICE_ID);
			printf("Init strings:\n");
			for (j = 0; ; j++)
			{
				if (dfptr->InitStrings[j] == NULL)
					break;
				printf("%s\n", dfptr->InitStrings[j]);
			}
			printf("\n");
			printf("Derivative Information\n");
			printf("----------------------\n");
			printf("Derivative ID        : %02X\n", deptr->DERIVATIVE_ID);
			printf("Derivative String    : %s\n", deptr->DERIVATIVE_STRING);
			printf("Features String      : %s\n", deptr->FEATURES_STRING);
			printf("Package String       : %s \n", deptr->PACKAGE_STRING);
			printf("Code Start Address   : %05X\n", deptr->CODE_START);
			printf("Code Size            : %05X\n", deptr->CODE_SIZE);
			printf("Write Lock Byte Addr : %05X\n", deptr->WRITELOCKBYTEADDR);
			printf("Read Lock Byte Addr  : %05X\n", deptr->READLOCKBYTEADDR);
			printf("Code 2 Start Address : %05X\n", deptr->CODE2_START);
			printf("Code 2 Size          : %05X\n", deptr->CODE2_SIZE);
			printf("\n");

			break;
		}
		case 24:	// Run Init String
		{
			result = NO_ERROR;
			printf("Execute Device Init String:\n");
			if (FamilyFound == true)
				CommandsList = KnownFamilies[FamilyNumber].InitStrings;
			else
				printf("Device not connected.\n");
			break;
		}
		case 25:	// C2 Flash Read <start addr> <length>
		{
			uint32_t addr;
			uint16_t length;

			printf("C2 Flash Read\n");
			cp = GetNextWord(instr);
			if (NO_ERROR == (result = CheckEmpty(cp)))
			{
				addr = atolx (cp);
				cp = GetNextWord(cp);
				if (NO_ERROR == (result = CheckEmpty(cp)))
				{
					length = atoi (cp);
					if (length > sizeof (BinDest))
						length = sizeof (BinDest);

					printf(
						"Reading %u bytes starting at address 0x%05lX\n",
						length,
						(unsigned long)addr
					);
					Start_Stopwatch ();
					result = C2_FLASH_Read (BinDest, addr, length);
					Stop_Stopwatch ();

					BIN2HEXSTR (HexDest, BinDest, length);
					printf("Memory contents are %s\n", HexDest);
				}
			}
			break;
		}
		case 26:	// C2 OTP Read <start addr> <length>
		{
			uint32_t addr;
			uint16_t length;

			printf("C2 OTP Read\n");
			cp = GetNextWord(instr);
			if (NO_ERROR == (result = CheckEmpty(cp)))
			{
				addr = atolx (cp);
				cp = GetNextWord(cp);
				if (NO_ERROR == (result = CheckEmpty(cp)))
				{
					length = atoi (cp);

					if (length > sizeof (BinDest))
						length = sizeof (BinDest);

					printf("Reading %u bytes starting at address 0x%05lX\n",
						length,
						(unsigned long)addr
					);
					Start_Stopwatch ();
					result = C2_OTP_Read (BinDest, addr, length);
					Stop_Stopwatch ();

					BIN2HEXSTR (HexDest, BinDest, length);
					printf("Memory contents are %s\n", HexDest);
				}
			}
			break;
		}
		case 27:	// C2 Flash Write <start addr> <hex string>
		{
			uint32_t addr;
			uint8_t length;

			printf("C2 Flash Write\n");
			cp = GetNextWord(instr);
			if (NO_ERROR == (result = CheckEmpty(cp)))
			{
				addr = atolx (cp);
				cp = GetNextWord(cp);
				if (NO_ERROR == (result = CheckEmpty(cp)))
				{
					// warning! 'dest' could be overtaken by a long string
					if (NO_ERROR == (result = HEXSTR2BIN (BinDest, cp, &length, sizeof(BinDest))))
					{
						printf("Writing %u bytes starting at address 0x%05X\n", length, addr);
						// printf("Writing the following string: %s\n", cp);
						Start_Stopwatch ();
						result = C2_FLASH_Write (addr, BinDest, length);
						Stop_Stopwatch ();
					}
				}
			}
			break;
		}
		case 28:	// C2 OTP Write <start addr> <hex string>
		{
			uint32_t addr;
			uint8_t length;

			printf("C2 OTP Write\n");
			cp = GetNextWord(instr);
			if (NO_ERROR == (result = CheckEmpty(cp)))
			{
				addr = atolx (cp);
				cp = GetNextWord(cp);
				if (NO_ERROR == (result = CheckEmpty(cp)))
				{

					if (NO_ERROR != (result = HEXSTR2BIN (BinDest, cp, &length, sizeof(BinDest))))
					{
						printf("Hex string too long");
						break;
					}

					printf(
						"Writing %u bytes starting at address 0x%05lX\n",
						(uint16_t) length,
						(unsigned long)addr
					);
					printf("Writing the following string: %s\n", cp);
					Start_Stopwatch ();
					result = C2_OTP_Write (addr, BinDest, length);
					Stop_Stopwatch ();
				}
			}
			break;
		}
		case 29:	// C2 Page Erase <address in page to erase>
		{
			uint32_t addr;

			printf("C2 Flash Page Erase\n");
			cp = GetNextWord(instr);
			if (NO_ERROR == (result = CheckEmpty(cp)))
			{
				addr = atolx (cp);

				printf("Erasing page containing address 0x%05X\n", addr);
				Start_Stopwatch ();
				result = C2_FLASH_PageErase (addr);
				Stop_Stopwatch ();
			}
			break;
		}
		case 30:	// C2 Device Erase
		{
			printf("C2 Flash Device Erase\n");

			printf("Erasing device...\n");
			Start_Stopwatch ();
			result = C2_FLASH_DeviceErase ();
			Stop_Stopwatch ();

			break;
		}
		case 31:	// C2 Flash Blank Check
		{
			uint32_t addr;
			uint32_t length;

			printf("C2 Flash Blank Check\n");

			addr = KnownFamilies[FamilyNumber].DerivativeList[DerivativeNumber].CODE_START;
			length = KnownFamilies[FamilyNumber].DerivativeList[DerivativeNumber].CODE_SIZE;

			printf("Checking starting at address 0x%05X for 0x%05X bytes: ", addr, length);
			Start_Stopwatch ();
			result = C2_FLASH_BlankCheck (addr, length);
			Stop_Stopwatch ();

			printf((result == DEVICE_IS_BLANK) ? "OK\n" : "Fail\n");
			break;
		}
		case 32:	// C2 OTP Blank Check
		{
			uint32_t addr;
			uint32_t length;

			printf("C2 OTP Blank Check\n");

			addr = KnownFamilies[FamilyNumber].DerivativeList[DerivativeNumber].CODE_START;
			length = KnownFamilies[FamilyNumber].DerivativeList[DerivativeNumber].CODE_SIZE;

			printf("Checking starting at address 0x%05X for 0x%05X bytes: ", addr, length);

			Start_Stopwatch ();
			result = C2_OTP_BlankCheck (addr, length);
			Stop_Stopwatch ();

			printf((result == NO_ERROR) ? "OK\n" : "Fail\n");
			break;
		}
		case 33:	// C2 Get Lock Byte value
		{
			printf("C2 Get Lock Byte\n");
			break;
		}
		case 34:	// Write Target to HEX
		{
			printf("Write Target to HEX:\n");
			Start_Stopwatch ();
			result = OP_Write_TARGET2HEX();
			Stop_Stopwatch ();

			break;
		}
		case 36:	// Write HEX to Target
		{
			HEX_RECORD hex;

			printf("Write HEX to Target:\n");

			cp = GetNextWord(instr);
			if (NO_ERROR == (result = CheckEmpty(cp)))
			{
				hex.Buf = BinDest;
				result = HEX_Decode(&hex, cp, sizeof(BinDest));
				if (result == NO_ERROR && hex.RECLEN != 0)
				{
					printf("Writing %u bytes starting at address 0x%05X\n", hex.RECLEN, hex.OFFSET.U16);
					Start_Stopwatch ();
					result = C2_FLASH_Write (hex.OFFSET.U16, hex.Buf, hex.RECLEN);
					Stop_Stopwatch ();
				}
				else if (result == EOF_HEX_RECORD)
					result = NO_ERROR;
			}
			break;
		}
		case 35:	// Read SFRs and directs
		{
			uint8_t row;
			uint8_t col;
			uint8_t value;

			Start_Stopwatch ();
			for (row = 0xF8; row != 0x00; row = row - 8)
			{
				for (col = 0; col != 0x08; col++)
				{
					if (NO_ERROR != (result = C2_ReadDirect ((row+col), &value, C2_DIRECT)))
						break;

					if (col == 0)
						printf("\n0X%02X: %02X", (uint16_t) (row), (uint16_t) value);
					else
						printf(" %02X", (uint16_t) value);
				}
			}
			printf("\n\n");
			Stop_Stopwatch ();
			break;
		}
		case 0xFE:
			break;
		default:
		{
			result = INVALID_COMMAND;
		}
	}
	printf("Result: %02X %s\n", result, GetErrorName(result));
	return result;
}

void BoardInit(void);

int main(void)
{
	BoardInit();
	Display_Menu();
	while (1)
	{
		CommandsList = NULL;
		if ((GetString() != 0) && (NO_ERROR == CommandDecode(Command)))
		{
			while (CommandsList != NULL && *CommandsList != NULL)
			{
				if (NO_ERROR != CommandDecode((char *)(*CommandsList)))
					break;
				CommandsList++;
			}
		}
	}
}

#if defined(__CC_ARM)
int fputc(int ch, FILE *f)
{
	PUTCHAR(ch);
	return ch;
}
#else
	#error "Unknown compiler"
#endif
