#include <stdio.h>
#include <stdlib.h>

#include "Common.h"
#include "Platform.h"
#include "Timing.h"
#include "C2_Utils.h"
#include "C2_Flash.h"
#include "Errors.h"
#include "Devices.h"

volatile uint8_t C2_AR;	// C2 Address register
volatile uint8_t C2_DR;	// C2 Data register

//-----------------------------------------------------------------------------
// C2_Reset
//-----------------------------------------------------------------------------
//
// Return Value : None
// Parameters   : None
//
// Performs a target device reset by pulling the C2CK pin low for >20us.
//
//-----------------------------------------------------------------------------
uint8_t C2_Reset(void)
{
	int EA_SAVE = DISABLE_INTERRUPTS();
	C2CK_DRIVER_ON();
	C2CK = 0;			// Put target device in reset state
	Wait_us(20);		// by driving C2CK low for >20us
	C2CK = 1;		// Release target device from reset
	Wait_us(2);			// wait at least 2us before Start
	C2CK_DRIVER_OFF();
	if (EA_SAVE) ENABLE_INTERRUPTS();

	FamilyFound = false;
	DerivativeFound = false;
	DeviceHalted = false;

	return NO_ERROR;
}

//-----------------------------------------------------------------------------
// C2_WriteAR
//-----------------------------------------------------------------------------
//
// Return Value : Error code
// Parameters   : value for address
//
// Performs a C2 Address register write (writes the <addr> input to Address
// register).
//
//-----------------------------------------------------------------------------
uint8_t C2_WriteAR(uint8_t addr)
{
	uint8_t i;
	int EA_SAVE = DISABLE_INTERRUPTS();
	
	C2CK_DRIVER_ON();
	// START field
	STROBE_C2CK();			// Strobe C2CK with C2D driver disabled

	// INS field (11b, LSB first)
	C2D_DRIVER_ON();		// Enable C2D driver (output)
	C2D = 1;
	STROBE_C2CK();
	C2D = 1;
	STROBE_C2CK();

	// send 8-bit address
	for (i = 0; i < 8; i++)
	{
		if (addr & 0x01)
		{
			C2D = 1;
		}
		else
		{
			C2D = 0;
		}
		STROBE_C2CK();
		addr >>= 1;
	}
	C2D_DRIVER_OFF();                  // Disable C2D driver
	// STOP field
	STROBE_C2CK();                     // Strobe C2CK with C2D driver disabled
	C2CK_DRIVER_OFF();

	if (EA_SAVE) ENABLE_INTERRUPTS();
	return NO_ERROR;
}

//-----------------------------------------------------------------------------
// C2_ReadAR
//-----------------------------------------------------------------------------
//
// Return Value : Error code, C2_AR global variable
// Parameters   : None
//
// Performs a C2 Address register read.
// Returns the 8-bit register content in global variable 'C2_AR'.  Return
// value is an error code.
//
//-----------------------------------------------------------------------------
uint8_t C2_ReadAR(void)
{
	int i;
	uint8_t addr = 0;
	int EA_SAVE = DISABLE_INTERRUPTS();

	C2CK_DRIVER_ON();
	// START field
	STROBE_C2CK();		   // Strobe C2CK with C2D driver disabled

	// INS field (10b, LSB first)
	C2D_DRIVER_ON();	// Enable C2D driver (output)
	C2D = 0;
	STROBE_C2CK();
	C2D = 1;
	STROBE_C2CK();

	C2D_DRIVER_OFF();

	// read 8-bit ADDRESS field
	for (i = 0; i < 8; i++)
	{
		addr >>= 1;
		STROBE_C2CK();
		if (C2D_IN != LOW)
			addr |= 0x80;
	}
	// STOP field
	STROBE_C2CK();
	C2CK_DRIVER_OFF();
	if (EA_SAVE) ENABLE_INTERRUPTS();

	C2_AR = addr;	// update global variable with result

	return NO_ERROR;
}

//-----------------------------------------------------------------------------
// C2_WriteDR
//-----------------------------------------------------------------------------
//
// Return Value : Error code
// Parameters   : data to write to C2
//
// Performs a C2 Data register write (writes <dat> input to data register).
// Requires Timeout_us_1 to be initialized prior to call.
//
//-----------------------------------------------------------------------------
uint8_t C2_WriteDR(uint8_t dat, uint16_t timeout_us)
{
	int i;
	int EA_SAVE = DISABLE_INTERRUPTS();
	uint8_t result = NO_ERROR;

	C2CK_DRIVER_ON();
	// START field
	STROBE_C2CK();                     // Strobe C2CK with C2D driver disabled

	// INS field (01b, LSB first)
	C2D_DRIVER_ON();                   // Enable C2D driver
	C2D = 1;
	STROBE_C2CK();
	C2D = 0;
	STROBE_C2CK();

	// LENGTH field (00b -> 1 byte)
	C2D = 0;
	STROBE_C2CK();
	C2D = 0;
	STROBE_C2CK();

	// write 8-bit DATA field
	for (i = 0; i < 8; i++)		// Shift out 8-bit DATA field
	{							// LSB-first
		if (dat & 0x01)
		{
			C2D = 1;
		}
		else
		{
			C2D = 0;
		}
		STROBE_C2CK();
		dat >>= 1;
	}

	// WAIT field
	C2D_DRIVER_OFF();
	STROBE_C2CK();

	SetTimeout_us(timeout_us);
	while (C2D_IN == LOW)
	{	// sample Wait until it returns High or until timeout expires
		if (IsDoneTimeout_us())
		{
			result = C2DR_WRITE_TIMEOUT;
			break;
		}
		STROBE_C2CK();
	}
	// STOP field
	STROBE_C2CK();
	C2CK_DRIVER_OFF();

	if (EA_SAVE) ENABLE_INTERRUPTS();

	return result;
}

//-----------------------------------------------------------------------------
// C2_ReadDR
//-----------------------------------------------------------------------------
//
// Return Value : Error code
// Parameters   : None
//
// Performs a C2 Data register read.
// Returns the 8-bit register content in global C2_DR.
// Requires Timeout_us_1 to be initialized prior to call.
//
//-----------------------------------------------------------------------------
uint8_t C2_ReadDR(uint16_t timeout_us)
{
	uint8_t i, data = 0;
	uint8_t result = NO_ERROR;
	int EA_SAVE = DISABLE_INTERRUPTS();

	C2CK_DRIVER_ON();
	// START field
	STROBE_C2CK();					// Strobe C2CK with C2D driver disabled

	// INS field (00b, LSB first)
	C2D_DRIVER_ON();                   // Enable C2D driver (output)
	C2D = 0;
	STROBE_C2CK();
	C2D = 0;
	STROBE_C2CK();

	// LENGTH field (00b -> 1 byte)
	C2D = 0;
	STROBE_C2CK();
	C2D = 0;
	STROBE_C2CK();

	// WAIT field
	C2D_DRIVER_OFF();		// Disable C2D driver (input)
	SetTimeout_us (timeout_us);
	STROBE_C2CK();		// stobe C2CK until Wait returns '1' or timeout
	while (C2D_IN == LOW)
	{
		if (IsDoneTimeout_us())
		{
			result = C2DR_READ_TIMEOUT;
			break;
		}
		STROBE_C2CK();
	}

	// 8-bit DATA field
	for (i = 0; i < 8; i++)	// Shift in 8-bit DATA field
	{						// LSB-first
		data >>= 1;
		STROBE_C2CK();
		if (C2D_IN == HIGH)
			data  |= 0x80;
	}
	// STOP field
	STROBE_C2CK();			// Strobe C2CK with C2D driver disabled
	C2CK_DRIVER_OFF();		// turn off C2CK driver

	if (EA_SAVE) ENABLE_INTERRUPTS();

	C2_DR = data;			// update global C2 DAT value
	return result;
}

//-----------------------------------------------------------------------------
// C2_Poll_InBusy
//-----------------------------------------------------------------------------
//
// Return Value : None
// Parameters   : None
//
// This function polls the INBUSY flag of C2_AR.
//
//-----------------------------------------------------------------------------
uint8_t C2_Poll_InBusy(uint16_t timeout_ms)
{
	uint8_t result = NO_ERROR;
	SetTimeout_ms (timeout_ms);
	while (1)
	{
		C2_ReadAR();
		if ((C2_AR & C2_AR_INBUSY) == LOW)
			break;	// exit on NO_ERROR and not busy

		if (IsDoneTimeout_ms())
		{
			// exit on POLL_INBUSY timeout
			result = C2_POLL_INBUSY_TIMEOUT;
			break;
		}
	}
	return result;
}

//-----------------------------------------------------------------------------
// C2_Poll_OutReady
//-----------------------------------------------------------------------------
//
// Return Value : None
// Parameters   : None
//
// This function polls the OUTREADY flag of C2_AR.
//
//-----------------------------------------------------------------------------
uint8_t C2_Poll_OutReady(uint16_t timeout_ms)
{
	uint8_t result = NO_ERROR;
	SetTimeout_ms(timeout_ms);
	while (1)
	{
		C2_ReadAR();
		if ((C2_AR & C2_AR_OUTREADY) != LOW)
			break;	// exit on NO_ERROR and data ready

		if (IsDoneTimeout_ms())
		{
			// exit on POLL_INBUSY timeout
			result = C2_POLL_OUTREADY_TIMEOUT;
			break;
		}
	}
	return result;
}


//-----------------------------------------------------------------------------
// C2_Halt
//-----------------------------------------------------------------------------
//
// Return Value : None
// Parameters   : None
//
// This routine issues a pin reset of the device, followed by a device
// reset, core reset, then Halt request.
//
//-----------------------------------------------------------------------------
uint8_t C2_Halt(void)
{
	uint8_t result;

	C2_Reset();

	C2_WriteAR(C2_FPCTL);

	// issue standard reset
	if (NO_ERROR == (result = C2_WriteDR(C2_FPCTL_RESET, C2_WRITE_DR_TIMEOUT_US))
	// issue core reset
	&&	NO_ERROR == (result = C2_WriteDR(C2_FPCTL_CORE_RESET, C2_WRITE_DR_TIMEOUT_US))
	// issue HALT
	&&	NO_ERROR == (result = C2_WriteDR(C2_FPCTL_HALT, C2_WRITE_DR_TIMEOUT_US))
		)
	{
		Wait_ms(20);	// wait at least 20 ms
		DeviceHalted = true;
	}
	return result;
}

//-----------------------------------------------------------------------------
// C2_ReadSFR
//-----------------------------------------------------------------------------
//
// Return Value : Error code
// Parameters   : sfraddress contains address to read, sfrdata points to
//                a result holding register
//
// This routine reads the contents of the SFR at address <sfraddress> and
// returns its value by reference into <sfrdata>.
//
//-----------------------------------------------------------------------------
uint8_t C2_ReadSFR(uint8_t sfr_address, uint8_t *sfr_data)
{
	C2_WriteAR(sfr_address);
	if (NO_ERROR != C2_ReadDR(C2_READ_DR_TIMEOUT_US))
		return SFR_READ_TIMEOUT;
	*sfr_data = C2_DR;
	return NO_ERROR;
}

//-----------------------------------------------------------------------------
// C2_WriteSFR
//-----------------------------------------------------------------------------
//
// Return Value : Error code
// Parameters   : sfraddress contains address to write, sfrdata contains data
//                to write
//
// This routine writes the contents of the SFR at address <sfraddress> to
// the value of <sfrdata>.
//
//-----------------------------------------------------------------------------
uint8_t C2_WriteSFR(uint8_t sfr_address, uint8_t sfr_data)
{
	C2_WriteAR(sfr_address);
	if (NO_ERROR != C2_WriteDR(sfr_data, C2_WRITE_DR_TIMEOUT_US))
		return SFR_WRITE_TIMEOUT;
	return NO_ERROR;
}

//-----------------------------------------------------------------------------
// C2_WriteCommand
//-----------------------------------------------------------------------------
//
// Return Value : Error code
// Parameters   : command
//
// This routine writes a C2 Flash command (WriteDR + INBUSY polling).
//
//-----------------------------------------------------------------------------
uint8_t C2_WriteCommand(uint8_t command, uint16_t C2_poll_inbusy_timeout_ms)
{
	uint8_t result;
	// Send command
	if (NO_ERROR != (result = C2_WriteDR(command, C2_WRITE_DR_TIMEOUT_US)))
		return result;
	// verify acceptance
	return C2_Poll_InBusy(C2_poll_inbusy_timeout_ms);
}

//-----------------------------------------------------------------------------
// C2_ReadResponse
//-----------------------------------------------------------------------------
//
// Return Value : Error code
// Parameters   : None
//
// This routine reads a C2 Flash command response (Outready polling + ReadDR).
//
//-----------------------------------------------------------------------------
uint8_t C2_ReadResponse(uint16_t C2_poll_outready_timeout_ms)
{
	uint8_t result;
	// check for response
	if (NO_ERROR == (result = C2_Poll_OutReady(C2_poll_outready_timeout_ms))
	// read status
	&&	NO_ERROR == (result = C2_ReadDR(C2_READ_DR_TIMEOUT_US))
	&&	C2_DR != COMMAND_OK
		)
	{
		result = ((C2_DR == C2_FPDAT_RETURN_INVALID_COMMAND) ? BAD_DEBUG_COMMAND : C2_DR);
	}
	return result;
}

//-----------------------------------------------------------------------------
// C2_ReadData
//-----------------------------------------------------------------------------
//
// Return Value : Error code
// Parameters   : None
//
// This routine reads a C2 Flash command data byte (Outready polling + ReadDR).
//
//-----------------------------------------------------------------------------
uint8_t C2_ReadData(uint16_t C2_poll_outready_timeout_ms)
{
	uint8_t result;
	// check for response
	if (NO_ERROR != (result = C2_Poll_OutReady(C2_poll_outready_timeout_ms)))
		return result;
	// read status
	return C2_ReadDR(C2_READ_DR_TIMEOUT_US);
}


//-----------------------------------------------------------------------------
// C2_ReadDirect
//-----------------------------------------------------------------------------
//
// Return Value : Error code
// Parameters   : sfraddress contains address to read, sfrdata points to
//                a result holding register
//
// This routine reads the contents of the SFR at address <sfraddress> and
// returns its value by reference into <sfrdata>.
// If <address> is 0x00 to 0x7f, this function accesses RAM.
// Requires that FPDAT is known and the device is Halted.
// If <indirect> is "C2_INDIRECT", <address> targets RAM for all addresses.
//
//-----------------------------------------------------------------------------
uint8_t C2_ReadDirect(uint8_t sfr_address, uint8_t *sfr_data, uint8_t indirect)
{
	uint8_t result;

	C2_WriteAR(KnownFamilies[FamilyNumber].FPDAT);
	// set up command accesses
	result =
		(indirect == C2_DIRECT)
		? C2_WriteCommand(C2_FPDAT_DIRECT_READ, C2_POLL_INBUSY_TIMEOUT_MS)
		: C2_WriteCommand(C2_FPDAT_INDIRECT_READ, C2_POLL_INBUSY_TIMEOUT_MS);
	if (NO_ERROR == result
	// Check command status
	&&	NO_ERROR == (result = C2_ReadResponse(C2_POLL_OUTREADY_TIMEOUT_MS))
	// now send address of byte to read
	&&	NO_ERROR == (result = C2_WriteCommand(sfr_address, C2_POLL_INBUSY_TIMEOUT_MS))
	// Send number of bytes to read
	&&	NO_ERROR == (result = C2_WriteCommand(1, C2_POLL_INBUSY_TIMEOUT_MS))
	// read the data
	&&	NO_ERROR == (result = C2_ReadData(C2_POLL_OUTREADY_TIMEOUT_MS))
		)
	{
		*sfr_data = C2_DR;
	}
	return result;
}

//-----------------------------------------------------------------------------
// C2_WriteDirect
//-----------------------------------------------------------------------------
//
// Return Value : Error code
// Parameters   : sfraddress contains address to write, sfrdata contains data
//                to write
//
// This routine writes <sfrdata> to address <sfraddress>.
// If <address> is 0x00 to 0x7f, this function accesses RAM.
// Requires that FPDAT is known and the device is Halted.
// If <indirect> is "C2_INDIRECT", <address> targets RAM for all addresses.
//
//-----------------------------------------------------------------------------
uint8_t C2_WriteDirect(uint8_t sfr_address, uint8_t sfr_data, uint8_t indirect)
{
	uint8_t result;

	// set up command accesses
	C2_WriteAR(KnownFamilies[FamilyNumber].FPDAT);
	result =
		(indirect == C2_DIRECT)
		? C2_WriteCommand(C2_FPDAT_DIRECT_WRITE, C2_POLL_INBUSY_TIMEOUT_MS)
		: C2_WriteCommand(C2_FPDAT_INDIRECT_WRITE, C2_POLL_INBUSY_TIMEOUT_MS);
	if (NO_ERROR == result
	// Check response
	&&	NO_ERROR == (result = C2_ReadResponse(C2_POLL_OUTREADY_TIMEOUT_MS))
	// now send address of byte to write
	&&	NO_ERROR == (result = C2_WriteCommand(sfr_address, C2_POLL_INBUSY_TIMEOUT_MS))
	// Send number of bytes to write
	&&	NO_ERROR == (result = C2_WriteCommand(1, C2_POLL_INBUSY_TIMEOUT_MS))
		)
	{
		// Send the data
		result = C2_WriteCommand(sfr_data, C2_POLL_INBUSY_TIMEOUT_MS);
	}
	return result;
}

//-----------------------------------------------------------------------------
// C2_GetDevID
//-----------------------------------------------------------------------------
//
// Return Value : None
// Parameters   : None
//
// This routine returns the device family ID by reference to <devid>.
//
//-----------------------------------------------------------------------------
uint8_t C2_GetDevID(uint8_t *devid)
{
	uint8_t temp, result;
	if (NO_ERROR == (result = C2_ReadSFR(C2_DEVICEID, &temp)))
		*devid = temp;
	return result;
}

//-----------------------------------------------------------------------------
// C2_GetRevID
//-----------------------------------------------------------------------------
//
// Return Value : None
// Parameters   : None
//
// This routine returns the device revision ID by reference to <revid>.
//
//-----------------------------------------------------------------------------
uint8_t C2_GetRevID(uint8_t *revid)
{
	uint8_t temp, result;
	if (NO_ERROR == (result = C2_ReadSFR(C2_REVID, &temp)))
		*revid = temp;
	return result;
}

//-----------------------------------------------------------------------------
// C2_Discover
//-----------------------------------------------------------------------------
//
// Return Value : Error code
// Parameters   : None
//
// This routine will eventually be replaced by C2_Discover().
//
// This routine queries the Device ID and performs a lookup to get the
// FPDAT register address for the target device family.  Assigns
// the global variables 'CURRENT_FAMILY' and 'CURRENT_DERIVATIVE'.
//
//-----------------------------------------------------------------------------
uint8_t C2_Discover(uint8_t * deviceId, uint8_t * revisionId, uint8_t * derId)
{
	uint8_t result;
	uint8_t devid, revid;
	uint8_t family_number;
	uint8_t derivative_number;
	uint16_t derivativeId;

	const DEVICE_FAMILY *dfptr;
	const DERIVATIVE_ENTRY *deptr;

	*deviceId = 0xFF;
	*revisionId = 0xFF;
	*derId = 0xFF;
	if (NO_ERROR != (result = C2_GetDevID(&devid)))
		return result;
	*deviceId = devid;
	if (NO_ERROR != (result = C2_GetRevID(&revid)))
		return result;
	*revisionId = revid;

	family_number = 0;
	FamilyFound = false;
	while ((FamilyFound == false) && (KnownFamilies[family_number].FAMILY_STRING != NULL))
	{
		if (devid == KnownFamilies[family_number].DEVICE_ID)
		{
			FamilyFound = true;
			FamilyNumber = family_number;
			break;
		}
		family_number++;
	}

	if (FamilyFound == false)
		return FAMILY_NOT_SUPPORTED;

	dfptr = &KnownFamilies[FamilyNumber];

	// Get derivative information
	C2_WriteAR(dfptr->FPDAT);
	if (NO_ERROR == (result = C2_WriteCommand(C2_FPDAT_GET_DERIVATIVE, C2_POLL_INBUSY_TIMEOUT_MS))
	&&	NO_ERROR == (result = C2_ReadResponse(C2_POLL_OUTREADY_TIMEOUT_MS))
	// now read the derivative value
	&&	NO_ERROR == (result = C2_ReadData(C2_POLL_OUTREADY_TIMEOUT_MS))
		)
	{
		derivativeId = (uint16_t) C2_DR;
		*derId = derivativeId;

		derivative_number = 0;
		DerivativeFound = false;
		deptr = &(dfptr->DerivativeList[0]);

		while (DerivativeFound == false && deptr->DERIVATIVE_STRING != NULL)
		{
			if (derivativeId == deptr->DERIVATIVE_ID)
			{
				DerivativeNumber = derivative_number;
				DerivativeFound = true;
				break;
			}
			else
			{
				derivative_number++;
				deptr = &(dfptr->DerivativeList[derivative_number]);
			}
		}

		if (DerivativeFound == false)
			return DERIVATIVE_NOT_SUPPORTED;
	}
	return result;
}
