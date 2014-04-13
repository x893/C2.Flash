#include <stdio.h>
#include <string.h>
#include <stdlib.h>

#include "em_usb.h"
#include "usbio.h"
#include "bsp.h"

#include "Devices.h"
#include "Errors.h"
#include "Timing.h"
#include "Pins.h"
#include "Serial.h"
#include "HEX_Utils.h"

#include "C2_Utils.h"
#include "C2_Flash.h"

#define VERSION "0.01"

typedef struct
{
	uint8_t		number;		// unique command number
	const char * name;		// unique command identifier string
	uint8_t		name_size;	// size of name above
	const char * usage;		// usage string
	const char * menu;		// menu string
	bool		display;	// flag to display command or not
} COMMAND;


const COMMAND Commands[] =
{
	{ 0, "da      ",	2, "da               ", "Device Autodetect", true},
	{ 1, "?       ",	1, "?                ", "Print Menu", true},
	{ 2, "wms     ",	3, "wms <16d>        ", "Wait ms", false},
	{ 3, "wus     ",	3, "wus <16d>        ", "Wait us", false},
	{ 4, "start   ",	5, "start            ", "Start Stopwatch", false},
	{ 5, "stop    ",	4, "stop             ", "Stop Stopwatch", false},
	{ 6, "stoms   ",	5, "stoms <16d>      ", "Set Timeout ms", false},
	{ 7, "stous   ",	5, "stous <16d>      ", "Set Timeout us", false},
	{ 8, "pi      ",	2, "pi               ", "Pin init", true},
	{ 9, "c2rst   ",	5, "c2rst            ", "C2 Reset", true},
	{10, "wa      ",	2, "wa <8h>          ", "C2 Write Address", true},
	{11, "ra      ",	2, "ra               ", "C2 Read Address", true},
	{12, "wd      ",	2, "wd <8h>          ", "C2 Write Data", true},
	{13, "rd      ",	2, "rd               ", "C2 Read Data", true},
	{14, "c2halt  ",	6, "c2halt           ", "C2 Reset and Halt", true},
	{15, "c2dev   ",	5, "c2dev            ", "C2 Get Device ID", true},
	{16, "c2rev   ",	5, "c2rev            ", "C2 Get Revision ID", true},
	{17, "c2rsfr  ",	6, "c2rsfr <8h>      ", "C2 Read SFR", true},
	{18, "c2wsfr  ",	6, "c2wsfr <8h> <8h> ", "C2 Write SFR", true},
	{19, "c2rd    ",	4, "c2rd <8h>        ", "C2 Read Direct", true},
	{20, "c2wd    ",	4, "c2wd <8h> <8h>   ", "C2 Write Direct", true},
	{21, "c2ri    ",	4, "c2ri <8h>        ", "C2 Read Indirect", true},
	{22, "c2wi    ",	4, "c2wi <8h> <8h>   ", "C2 Write Indirect", true},
	{23, "c2d     ",	3, "c2d              ", "C2 Discover", true},
	{24, "init    ",	4, "init             ", "Run Init String", true},
	{25, "c2fr    ",	4, "c2fr <32h> <16d> ", "C2 Flash Read <start addr> <length>", true},
	{26, "c2or    ",	4, "c2or <32h> <16d> ", "C2 OTP Read <start addr> <length>", true},
	{27, "c2fw    ",	4, "c2fw <32h> <hex> ", "C2 Flash Write <start addr> <hex string>", true},
	{28, "c2ow    ",	4, "c2ow <32h> <hex> ", "C2 OTP Write <start addr> <hex string>", true},
	{29, "c2fpe   ",	5, "c2fpe <32h>      ", "C2 Page Erase <address in page to erase>", true},
	{30, "c2fde   ",	5, "c2fde            ", "C2 Device Erase", true},
	{31, "c2fbc   ",	5, "c2fbc            ", "C2 Flash Blank Check", true},
	{32, "c2obc   ",	5, "c2obc            ", "C2 OTP Blank Check", true},
	{33, "c2glb   ",	5, "c2glb            ", "C2 Get Lock Byte value", true},
	{34, "wt2h    ",	4, "wt2h             ", "Write Target to HEX", true},
	{35, "rsfrs   ",	5, "rsfrs            ", "Read SFRs", true},
	{00, NULL,			0, NULL,				NULL, false},
	{99, "",			0, "Error            ", "", true}
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
	char * buffer = Command;
	int max_length = sizeof(Command) - 1;

	printf("\r\n> ");

	while(1)
	{
		SetLedPeriod(900, 100);

		c = GETCHAR();
		if (c != '\0')
		{
			SetLedPeriod(0, 0);

			PUTCHAR(c);
			if (c == '\b')
			{
				if (len != 0)
				{
					--len;
					--buffer;
				}
			}
			else if (c == '\r' || c == '\n')
			{
				if (c == '\r')
					PUTCHAR('\n');
				*buffer = '\0';
				return len;
			}
			else if (len != max_length)
			{
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
// Parameters   : family_number and derivative number
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
	uint8_t return_value = NO_ERROR;
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

		if (mem_type == FLASH)
		{
			// read the target buffer
			if (NO_ERROR != (return_value = C2_FLASH_Read (BinDest, address, reclen)))
				return return_value;
		}
		else if (mem_type == OTP)
		{
			// read the target buffer
			if (NO_ERROR != (return_value = C2_OTP_Read (BinDest, address, reclen)))
				return return_value;
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

	return return_value;
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
	uint16_t deviceid = 0xFFFF;		// initialize device and derivative
	uint16_t derivativeid = 0xFFFF;	// id's to invalid selections
	uint8_t return_value = INVALID_COMMAND;

	printf("Command: %s\n", instr);
	if (instr[0] >= '0' && instr[0] <= '9')
	{	// if first char is a digit, then interpret it as a command number
		command_number = atoi (instr);
	}
	else
	{	// interpret command as a string and find command number
		const COMMAND *ctptr = Commands;
		while (ctptr->name != NULL)
		{
			if (strncmp (instr, ctptr->name, ctptr->name_size) == 0)
			{	// we've found the command, so record its number and exit
				command_number = ctptr->number;
				break;
			}
			ctptr++;
		}
	}

	// Now we have a command number, so act on it.
	switch (command_number)
	{
		case 0:	// Device Autodetect
		{
			printf("Device Autodetect\n");
			Start_Stopwatch();
			if (NO_ERROR == (return_value = Pin_Init())
			&&	NO_ERROR == (return_value = C2_Halt ())
			&&	NO_ERROR == (return_value = C2_Discover (&deviceid, &derivativeid))
				)
			{
				CommandsList = KnownFamilies[FamilyNumber].InitStrings;
			}
			Stop_Stopwatch();
			printf("Device ID returned 0x%04x\n", deviceid);
			printf("Derivative ID returned 0x%04x\n", derivativeid);
			break;
		}
		case 1:	// Print Menu
		{
			printf("? stub\n");
			Start_Stopwatch();
			Display_Menu();
			Stop_Stopwatch();
			return_value = NO_ERROR;
			break;
		}
		case 2:	// Wait ms
		{
			uint16_t wait_time;
			cp = instr;
			while (*cp++ != ' ');
			wait_time = atoi (cp);
			printf("Waiting %d ms\n", wait_time);
			Start_Stopwatch();
			Wait_ms (wait_time);
			Stop_Stopwatch();
			printf("Stopwatch_ms is %u\n", Stopwatch_ms);
			return_value = NO_ERROR;
			break;
		}
		case 3:	// Wait us
		{
			uint16_t wait_time;
			cp = instr;
			while (*cp++ != ' ');
			wait_time = atoi (cp);

			printf("Waiting %d us\n", wait_time);
			Start_Stopwatch();
			Wait_us (wait_time);
			Stop_Stopwatch();
			printf("Stopwatch_us is %u\n", Stopwatch_us);

			return_value = NO_ERROR;
			break;
		}
		case 4:	// Start Stopwatch
		{
			printf("Start Stopwatch\n");
			return_value = Start_Stopwatch();
			break;
		}
		case 5:	// Stop Stopwatch
		{
			printf("Stop Stopwatch\n");
			return_value = Stop_Stopwatch();
			printf("Stopwatch_ms is %u\n", Stopwatch_ms);
			printf("Stopwatch_us is %u\n", Stopwatch_us);
			break;
		}
		case 6:	// Set Timeout ms
		{
			uint16_t wait_time;
			printf("Set Timeout ms:\n");
			cp = instr;
			while (*cp++ != ' ');
			wait_time = atoi (cp);

			printf("Timing out for %d ms\n", wait_time);
			Start_Stopwatch();
			Set_Timeout_ms_1 (wait_time);
			while (!Timeout_ms_1());
			Stop_Stopwatch();
			printf("Stopwatch_ms is %u\n", Stopwatch_ms);
			return_value = NO_ERROR;
			break;
		}
		case 7:	// Set Timeout us
		{
			uint16_t wait_time;
			printf("Set Timeout us\n");
			cp = instr;
			while (*cp++ != ' ');
			wait_time = atoi (cp);

			printf("Timing out for %d us\n", wait_time);
			Start_Stopwatch();
			Set_Timeout_us_1 (wait_time);
			while (!Timeout_us_1());
			Stop_Stopwatch();
			printf("Stopwatch_us is %u\n", Stopwatch_us);

			return_value = NO_ERROR;
			break;
		}
		case 8:	// Pin init
		{
			printf("Pin Init\n");
			return_value = Pin_Init();
			break;
		}
		case 9:	// C2 Reset
		{
			printf("C2 Reset\n");
			return_value = C2_Reset();
			break;
		}
		case 10:	// C2 Write Address
		{
			uint16_t addr;
			printf("C2 Write Address\n");
			cp = instr;
			while (*cp++ != ' ');
			addr = atox (cp);

			printf("Writing address 0x%02x\n", addr);
			Start_Stopwatch ();
			return_value = C2_WriteAR ((uint8_t) addr);
			Stop_Stopwatch ();
			break;
		}
		case 11:	// C2 Read Address
		{
			printf("C2 Read Address\n");
			Start_Stopwatch ();
			return_value = C2_ReadAR ();
			Stop_Stopwatch ();
			printf("Address returned is 0x%02x\n", (uint16_t) C2_AR);
			break;
		}
		case 12:	// C2 Write Data
		{
			uint8_t thedata;
			printf("C2 Write Data\n");
			cp = instr;
			while (*cp++ != ' ');
			thedata = (uint8_t) atox (cp);

			printf("Writing %u\n", (uint16_t) thedata);
			Start_Stopwatch ();
			return_value = C2_WriteDR (thedata, C2_WRITE_DR_TIMEOUT_US);
			Stop_Stopwatch ();
			break;
		}
		case 13:	// C2 Read Data
		{
			printf("C2 Read Data\n");
			Start_Stopwatch ();
			return_value = C2_ReadDR (C2_READ_DR_TIMEOUT_US);
			Stop_Stopwatch ();
			printf("Data register is 0x%02x\n", (uint16_t) C2_DR);
			break;
		}
		case 14:	// C2 Reset and Halt
		{
			printf("C2 Reset and Halt\n");
			return_value = C2_Halt ();
			break;
		}
		case 15:	// C2 Get Device ID
		{
			uint16_t devid;

			printf("C2 Get Device ID\n");
			Start_Stopwatch ();
			return_value = C2_GetDevID (&devid);
			Stop_Stopwatch ();
			printf("Device ID is %u, 0x%04x\n", devid, devid);
			break;
		}
		case 16:	// C2 Get Revision ID
		{
			uint16_t revid;

			printf("C2 Get Revision ID\n");
			Start_Stopwatch ();
			return_value = C2_GetRevID (&revid);
			Stop_Stopwatch ();
			printf("Revision ID is %u, 0x%04x\n", revid, revid);
			break;
		}
		case 17:	// C2 Read SFR
		{
			uint8_t sfr_value, sfr_address;

			printf("C2 Read SFR\n");
			cp = instr;
			while (*cp++ != ' ');
			sfr_address = (uint8_t) atox (cp);

			printf("Reading SFR 0x%02x\n", (uint16_t) sfr_address);
			Start_Stopwatch ();
			return_value = C2_ReadSFR (sfr_address, &sfr_value);
			Stop_Stopwatch ();
			printf("Read SFR returned 0x%02x\n", (uint16_t) sfr_value);
			break;
		}
		case 18:	// C2 Write SFR
		{
			uint8_t sfr_address, sfr_value;

			printf("C2 Write SFR\n");
			cp = instr;
			while (*cp++ != ' ');
			sfr_address = (uint8_t) atox (cp);
			while (*cp++ != ' ');
			sfr_value = (uint8_t) atox (cp);

			printf(
				"Writing 0x%02x to address 0x%02x\n",
				(uint16_t) sfr_value,
				(uint16_t) sfr_address
			);
			Start_Stopwatch ();
			return_value = C2_WriteSFR (sfr_address, sfr_value);
			Stop_Stopwatch ();
			break;
		}
		case 19:	// C2 Read Direct
		{
			uint8_t sfr_value, sfr_address;
			printf("C2 Read Direct\n");
			cp = instr;
			while (*cp++ != ' ');
			sfr_address = (uint8_t) atox (cp);

			printf("Reading Direct 0x%02x\n", (uint16_t) sfr_address);
			Start_Stopwatch ();
			return_value = C2_ReadDirect (sfr_address, &sfr_value, C2_DIRECT);
			Stop_Stopwatch ();
			printf("Read Direct returned 0x%02x\n", (uint16_t) sfr_value);

			break;
		}
		case 20:	// C2 Write Direct <address> <value>
		{
			uint8_t sfr_address, sfr_value;

			printf("C2 Write Direct\n");
			cp = instr;
			while (*cp++ != ' ');
			sfr_address = (uint8_t) atox (cp);
			while (*cp++ != ' ');
			sfr_value = (uint8_t) atox (cp);

			printf(
				"Writing 0x%02x to address 0x%02x\n",
				(uint16_t) sfr_value,
				(uint16_t) sfr_address
			);
			Start_Stopwatch ();
			return_value = C2_WriteDirect (sfr_address, sfr_value, C2_DIRECT);
			Stop_Stopwatch ();
			break;
		}
		case 21:	// C2 Read Indirect
		{
			uint8_t sfr_value, sfr_address;
			
			printf("C2 Read Indirect\n");
			cp = instr;
			while (*cp++ != ' ');
			sfr_address = (uint8_t) atox (cp);

			printf("Reading Indirect 0x%02x\n", (uint16_t) sfr_address);
			Start_Stopwatch ();
			return_value = C2_ReadDirect (sfr_address, &sfr_value, C2_INDIRECT);
			Stop_Stopwatch ();
			printf("Read Indirect returned 0x%02x\n", (uint16_t) sfr_value);

			break;
		}
		case 22:	// C2 Write Indirect
		{
			uint8_t sfr_address;
			uint8_t sfr_value;

			printf("C2 Write Indirect\n");
			cp = instr;
			while (*cp++ != ' ');
			sfr_address = (uint8_t) atox (cp);
			while (*cp++ != ' ');
			sfr_value = (uint8_t) atox (cp);

			printf(
				"Writing 0x%02x to address 0x%02x\n",
				(uint16_t) sfr_value,
				(uint16_t) sfr_address
			);
			Start_Stopwatch ();
			return_value = C2_WriteDirect (sfr_address, sfr_value, C2_INDIRECT);
			Stop_Stopwatch ();

			break;
		}
		case 23:	// C2 Discover
		{
			uint8_t j;

			printf("C2 Discover\n");
			Start_Stopwatch ();
			return_value = C2_Discover (&deviceid, &derivativeid);
			Stop_Stopwatch ();

			if (return_value != NO_ERROR)
				break;

			dfptr = &(KnownFamilies[FamilyNumber]);
			deptr = &(KnownFamilies[FamilyNumber].DerivativeList[DerivativeNumber]);

			printf("Family Information:\n");
			printf("Device ID: 0x%04x\n", dfptr->DEVICE_ID);
			printf("Family string: %s\n", dfptr->FAMILY_STRING);
			printf("Mem Type: %u\n", (uint16_t) dfptr->MEM_TYPE);
			printf("Page Size: %u\n", dfptr->PAGE_SIZE);
			printf("Has SFLE: %u\n", (uint16_t) dfptr->HAS_SFLE);
			printf("Security Type: %u\n", (uint16_t) dfptr->SECURITY_TYPE);
			printf("FPDAT address: 0x%02x\n", (uint16_t) dfptr->FPDAT);
			printf("Device ID: 0x%04x\n", dfptr->DEVICE_ID);
			printf("Init strings:\n");
			for (j = 0; ; j++)
			{
				if (dfptr->InitStrings[j] == NULL)
					break;
				printf("%s\n", dfptr->InitStrings[j]);
			}
			printf("\n");
			printf("Derivative Information:\n");
			printf("Derivative ID: 0x%04x\n", deptr->DERIVATIVE_ID);
			printf("Derivative String: %s\n", deptr->DERIVATIVE_STRING);
			printf("Features String: %s\n", deptr->FEATURES_STRING);
			printf("Package String: %s \n", deptr->PACKAGE_STRING);
			printf("Code Start Address: 0x%05lx\n", (unsigned long)deptr->CODE_START);
			printf("Code Size: 0x%05lx\n", (unsigned long)deptr->CODE_SIZE);
			printf("Write Lock Byte Addr: 0x%05lx\n", (unsigned long)deptr->WRITELOCKBYTEADDR);
			printf("Read Lock Byte Addr: 0x%05lx\n", (unsigned long)deptr->READLOCKBYTEADDR);
			printf("Code 2 Start Address: 0x%05lx\n", (unsigned long)deptr->CODE2_START);
			printf("Code 2 Size: 0x%05lx\n", (unsigned long)deptr->CODE2_SIZE);
			printf("\n");

			break;
		}
		case 24:	// Run Init String
		{
			return_value = NO_ERROR;
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
			cp = instr;
			while (*cp++ != ' ');
			addr = (uint32_t) atolx (cp);
			while (*cp++ != ' ');
			length = (uint16_t) atoi (cp);
			if (length > sizeof (BinDest))
				length = sizeof (BinDest);

			printf(
				"Reading %u bytes starting at address 0x%05lx\n",
				length,
				(unsigned long)addr
			);
			Start_Stopwatch ();
			return_value = C2_FLASH_Read (BinDest, addr, length);
			Stop_Stopwatch ();

			BIN2HEXSTR (HexDest, BinDest, length);
			printf("Memory contents are %s\n", HexDest);

			break;
		}
		case 26:	// C2 OTP Read <start addr> <length>
		{
			uint32_t addr;
			uint16_t length;

			printf("C2 OTP Read\n");
			cp = instr;
			while (*cp++ != ' ');
			addr = (uint32_t) atolx (cp);
			while (*cp++ != ' ');
			length = (uint16_t) atoi (cp);

			if (length > sizeof (BinDest))
				length = sizeof (BinDest);

			printf("Reading %u bytes starting at address 0x%05lx\n",
				length,
				(unsigned long)addr
			);
			Start_Stopwatch ();
			return_value = C2_OTP_Read (BinDest, addr, length);
			Stop_Stopwatch ();

			BIN2HEXSTR (HexDest, BinDest, length);
			printf("Memory contents are %s\n", HexDest);
			break;
		}
		case 27:	// C2 Flash Write <start addr> <hex string>
		{
			uint32_t addr;
			uint8_t length;

			printf("C2 Flash Write\n");
			cp = instr;
			while (*cp++ != ' ');
			addr = (uint32_t) atolx (cp);
			while (*cp++ != ' ');

			// warning! 'dest' could be overtaken by a long string
			if (NO_ERROR != (return_value = HEXSTR2BIN (BinDest, cp, &length, sizeof(BinDest))))
			{
				printf("Hex string too long");
				break;
			}

			printf(
				"Writing %u bytes starting at address 0x%05lx\n",
				(uint16_t) length,
				(unsigned long)addr
			);
			printf("Writing the following string: %s\n", cp);
			Start_Stopwatch ();
			return_value = C2_FLASH_Write (addr, BinDest, length);
			Stop_Stopwatch ();
			break;
		}
		case 28:	// C2 OTP Write <start addr> <hex string>
		{
			uint32_t addr;
			uint8_t length;

			printf("C2 OTP Write\n");
			cp = instr;
			while (*cp++ != ' ');
			addr = (uint32_t) atolx (cp);
			while (*cp++ != ' ');

			if (NO_ERROR != (return_value = HEXSTR2BIN (BinDest, cp, &length, sizeof(BinDest))))
			{
				printf("Hex string too long");
				break;
			}

			printf(
				"Writing %u bytes starting at address 0x%05lx\n",
				(uint16_t) length,
				(unsigned long)addr
			);
			printf("Writing the following string: %s\n", cp);
			Start_Stopwatch ();
			return_value = C2_OTP_Write (addr, BinDest, length);
			Stop_Stopwatch ();
			break;
		}
		case 29:	// C2 Page Erase <address in page to erase>
		{
			uint32_t addr;

			printf("C2 Flash Page Erase\n");
			cp = instr;
			while (*cp++ != ' ');
			addr = (uint32_t) atolx (cp);

			printf("Erasing page containing address 0x%05lx\n", (unsigned long)addr);
			Start_Stopwatch ();
			return_value = C2_FLASH_PageErase (addr);
			Stop_Stopwatch ();

			break;
		}
		case 30:	// C2 Device Erase
		{
			printf("C2 Flash Device Erase\n");

			printf("Erasing device...\n");
			Start_Stopwatch ();
			return_value = C2_FLASH_DeviceErase ();
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

			printf(
				"Checking starting at address 0x%05lx for 0x%05lx bytes:\n",
				(unsigned long)addr,
				(unsigned long)length
			);

			Start_Stopwatch ();
			return_value = C2_FLASH_BlankCheck (addr, length);
			Stop_Stopwatch ();

			break;
		}
		case 32:	// C2 OTP Blank Check
		{
			uint32_t addr;
			uint32_t length;

			printf("C2 OTP Blank Check\n");

			addr = KnownFamilies[FamilyNumber].DerivativeList[DerivativeNumber].CODE_START;
			length = KnownFamilies[FamilyNumber].DerivativeList[DerivativeNumber].CODE_SIZE;

			printf(
				"Checking starting at address 0x%05lx for 0x%05lx bytes:\n",
				(unsigned long)addr,
				(unsigned long)length
			);

			Start_Stopwatch ();
			return_value = C2_OTP_BlankCheck (addr, length);
			Stop_Stopwatch ();

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
			return_value = OP_Write_TARGET2HEX ();
			Stop_Stopwatch ();

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
					if (NO_ERROR != (return_value = C2_ReadDirect ((row+col), &value, C2_DIRECT)))
						break;

					if (col == 0)
						printf("\n0x%02x: %02x", (uint16_t) (row), (uint16_t) value);
					else
						printf(" %02x", (uint16_t) value);
				}
			}
			printf("\n\n");
			Stop_Stopwatch ();
			break;
		}
		default:
		{
			printf("Invalid command\n");
			return_value = INVALID_COMMAND;
		}
	}
	return return_value;
}

void c2_main(void)
{
	while (1)
	{
		CommandsList = NULL;
		if (GetString() != 0 && NO_ERROR == CommandDecode(Command))
			while (CommandsList != NULL)
			{
				CommandDecode((char *)(*CommandsList));
				CommandsList++;
			}
	}
}
