#include <stdio.h>
#include <stdlib.h>

#include "Timing.h"
#include "Pins.h"
#include "C2_Utils.h"
#include "C2_Flash.h"
#include "Errors.h"
#include "Devices.h"

uint8_t C2_Reset (void);
uint8_t C2_WriteAR (uint8_t addr);
uint8_t C2_ReadAR (void);
uint8_t C2_WriteDR (uint8_t dat, uint16_t timeout_us);
uint8_t C2_ReadDR (uint16_t timeout_us);

uint8_t C2_Poll_InBusy (uint16_t timeout_ms);
uint8_t C2_Poll_OutReady (uint16_t timeout_ms);
uint8_t C2_Poll_OTPBusy (uint16_t timeout_ms);

uint8_t C2_Halt (void);
uint8_t C2_GetDevID (uint16_t *devid);
uint8_t C2_GetRevID (uint16_t *revid);
uint8_t C2_ReadSFR (uint8_t sfraddress, uint8_t *sfrdata);
uint8_t C2_WriteSFR (uint8_t sfraddress, uint8_t sfrdata);

uint8_t C2_WriteCommand (uint8_t command, uint16_t C2_poll_inbusy_timeout_ms);
uint8_t C2_ReadResponse (uint16_t C2_poll_outready_timeout_ms);
uint8_t C2_ReadData (uint16_t C2_poll_outready_timeout_ms);

uint8_t C2_ReadDirect (uint8_t sfraddress, uint8_t *sfrdata, uint8_t indirect);
uint8_t C2_WriteDirect (uint8_t sfraddress, uint8_t sfrdata, uint8_t indirect);

uint8_t C2_Discover (uint16_t* deviceid, uint16_t* derid);

uint8_t C2_AR;                        // C2 Address register
uint8_t C2_DR;                        // C2 Data register


#define LOW		0
#define HIGH	1

void C2CK_DRIVER_ON(void);
void C2CK_DRIVER_OFF(void);

void C2D_DRIVER_ON(void);
void C2D_DRIVER_OFF(void);

void STROBE_C2CK(void);
void C2CK_LOW(void);
void C2CK_HIGH(void);

void C2D_LOW(void);
void C2D_HIGH(void);
unsigned int C2D_READ(void);

#define DISABLE_INTERRUPTS()	__disable_irq()
#define ENABLE_INTERRUPTS()		__enable_irq()

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
uint8_t C2_Reset (void)
{
   C2CK_DRIVER_ON();
   C2CK_LOW();                         // Put target device in reset state
   Wait_us(20);                       // by driving C2CK low for >20us

   C2CK_HIGH();                        // Release target device from reset
   Wait_us(2);                        // wait at least 2us before Start
   C2CK_DRIVER_OFF();

   FAMILY_FOUND = false;
   DERIVATIVE_FOUND = false;
   DEVICE_HALTED = false;

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
uint8_t C2_WriteAR (uint8_t addr)
{
	uint8_t i;
	int EA_SAVE = DISABLE_INTERRUPTS();
	C2CK_DRIVER_ON();

	// START field
	STROBE_C2CK();                     // Strobe C2CK with C2D driver disabled

	// INS field (11b, LSB first)
	C2D_DRIVER_ON();                   // Enable C2D driver (output)
	C2D_HIGH();
	STROBE_C2CK();
	C2D_HIGH();
	STROBE_C2CK();

   // send 8-bit address
	for (i = 0; i < 8; i++)
	{
		if (addr & 0x01)
		{
			C2D_HIGH();
		}
		else
		{
			C2D_LOW();
		}
		STROBE_C2CK();
		addr >>= 1;
	}

	// STOP field
	C2D_DRIVER_OFF();                  // Disable C2D driver
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
uint8_t C2_ReadAR (void)
{
	uint8_t i;
	uint8_t addr;
	int EA_SAVE = DISABLE_INTERRUPTS();

	C2CK_DRIVER_ON();
	// START field
	STROBE_C2CK();

	// INS field (10b, LSB first)
	C2D_LOW();
	C2D_DRIVER_ON();	// Enable C2D driver (output)
	STROBE_C2CK();
	C2D_HIGH();
	STROBE_C2CK();

	C2D_DRIVER_OFF();

	// read 8-bit ADDRESS field
	addr = 0;
	for (i = 0; i < 8; i++)
	{
      addr >>= 1;
      STROBE_C2CK();
      if (C2D_READ() == HIGH)
         addr |= 0x80;
	}
	C2_AR = addr;	// update global variable with result

	// STOP field
	STROBE_C2CK();

	C2CK_DRIVER_OFF();

	if (EA_SAVE) ENABLE_INTERRUPTS();
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
uint8_t C2_WriteDR (uint8_t dat, uint16_t timeout_us)
{
	uint8_t i;                               // bit counter
	int EA_SAVE = DISABLE_INTERRUPTS();
	uint8_t return_value = NO_ERROR;

	C2CK_DRIVER_ON();
	// START field
	STROBE_C2CK();                     // Strobe C2CK with C2D driver disabled

	// INS field (01b, LSB first)
	C2D_HIGH();
	C2D_DRIVER_ON();                   // Enable C2D driver
	STROBE_C2CK();
	C2D_LOW();
	STROBE_C2CK();

	// LENGTH field (00b -> 1 byte)
	C2D_LOW();
	STROBE_C2CK();
	C2D_LOW();
	STROBE_C2CK();

	// write 8-bit DATA field
	for (i = 0; i < 8; i++)             // Shift out 8-bit DATA field
	{                                   // LSB-first
		if (dat & 0x01)
		{
			C2D_HIGH();
		}
		else
		{
			C2D_LOW();
		}
		STROBE_C2CK();
		dat >>= 1;
	}

	// WAIT field
	C2D_DRIVER_OFF();
	STROBE_C2CK();

	Set_Timeout_us_1(timeout_us);
	while (C2D_READ() == LOW && !Timeout_us_1())
	{
		STROBE_C2CK();	// sample Wait until it returns High
						// or until timeout expires
	}

	if ((C2D_READ() == LOW) && (Timeout_us_1() == 1))
	{
		return_value = C2DR_WRITE_TIMEOUT;
	}
	// STOP field
	STROBE_C2CK();

	C2CK_DRIVER_OFF();

	if (EA_SAVE) ENABLE_INTERRUPTS();
	return return_value;
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
uint8_t C2_ReadDR (uint16_t timeout_us)
{
	uint8_t i;
	uint8_t dat;
	uint8_t return_value = NO_ERROR;
	int EA_SAVE = DISABLE_INTERRUPTS();

	C2CK_DRIVER_ON();
	// START field
	STROBE_C2CK();                     // Strobe C2CK with C2D driver disabled

	// INS field (00b, LSB first)
	C2D_DRIVER_ON();                   // Enable C2D driver (output)
	C2D_LOW();
	STROBE_C2CK();
	C2D_LOW();
	STROBE_C2CK();

	// LENGTH field (00b -> 1 byte)
	C2D_LOW();
	STROBE_C2CK();
	C2D_LOW();
	STROBE_C2CK();

	// WAIT field
	C2D_DRIVER_OFF();                  // Disable C2D driver for input
	STROBE_C2CK();                     // sample first Wait cycle

	Set_Timeout_us_1 (timeout_us);
	while (C2D_READ() == LOW && !Timeout_us_1())
	{
      STROBE_C2CK();	// stobe C2CK until Wait returns '1' or timeout
	}

	if ((C2D_READ() == LOW) && (Timeout_us_1() == 1))
	{
		return_value = C2DR_READ_TIMEOUT;
	}
	// 8-bit DATA field
	dat = 0;
	for (i = 0; i < 8; i++)             // Shift in 8-bit DATA field
	{                                   // LSB-first
		dat >>= 1;
		STROBE_C2CK();
		if (C2D_READ() == HIGH)
		{
			dat  |= 0x80;
		}
	}
	C2_DR = dat;                        // update global C2 DAT value

	// STOP field
	STROBE_C2CK();                     // Strobe C2CK with C2D driver disabled
	C2CK_DRIVER_OFF();                 // turn off C2CK driver
	if (EA_SAVE) ENABLE_INTERRUPTS();
	return return_value;
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
uint8_t C2_Poll_InBusy (uint16_t timeout_ms)
{
	uint8_t return_value = NO_ERROR;
	Set_Timeout_ms_1 (timeout_ms);
	while (1)
	{
		C2_ReadAR();
		if ((C2_AR & C2_AR_INBUSY) == 0)
			break;	// exit on NO_ERROR and not busy

		if (Timeout_ms_1())
		{
			// exit on POLL_INBUSY timeout
			return_value = C2_POLL_INBUSY_TIMEOUT;
			break;
		}
	}
	return return_value;
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
uint8_t C2_Poll_OutReady (uint16_t timeout_ms)
{
	uint8_t return_value = NO_ERROR;
	Set_Timeout_ms_1 (timeout_ms);
	while (1)
	{
		C2_ReadAR();
		if (C2_AR & C2_AR_OUTREADY)
			break;	// exit on NO_ERROR and data ready

		if (Timeout_ms_1())
		{
			// exit on POLL_INBUSY timeout
			return_value = C2_POLL_OUTREADY_TIMEOUT;
			break;
		}
	}
	return return_value;
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
uint8_t C2_Halt (void)
{
	uint8_t return_value;

	C2_Reset();

	// issue standard reset
	C2_WriteAR (C2_FPCTL);
	if (NO_ERROR != (return_value = C2_WriteDR(C2_FPCTL_RESET, C2_WRITE_DR_TIMEOUT_US)))
		return return_value;

	// issue core reset
	if (NO_ERROR != (return_value = C2_WriteDR (C2_FPCTL_CORE_RESET, C2_WRITE_DR_TIMEOUT_US)))
		return return_value;

	// issue HALT
	if (NO_ERROR != (return_value = C2_WriteDR (C2_FPCTL_HALT, C2_WRITE_DR_TIMEOUT_US)))
		return return_value;

	Wait_ms (20);	// wait at least 20 ms
	DEVICE_HALTED = true;
	return return_value;
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
uint8_t C2_GetDevID (uint16_t *devid)
{
	uint8_t return_value;
	uint8_t temp;
	if (NO_ERROR != (return_value = C2_ReadSFR (C2_DEVICEID, &temp)))
		return return_value;

	*devid = temp;
	return return_value;
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
uint8_t C2_GetRevID (uint16_t *revid)
{
	uint8_t return_value;
	uint8_t temp;

	if (NO_ERROR != (return_value = C2_ReadSFR (C2_REVID, &temp)))
      return return_value;

	*revid = temp;
	return return_value;
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
uint8_t C2_ReadSFR (uint8_t sfraddress, uint8_t *sfrdata)
{
	uint8_t return_value;

	C2_WriteAR (sfraddress);
	if (NO_ERROR != (return_value = C2_ReadDR (C2_READ_DR_TIMEOUT_US)))
		return SFR_READ_TIMEOUT;

	*sfrdata = C2_DR;
	return return_value;
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
uint8_t C2_WriteSFR (uint8_t sfraddress, uint8_t sfrdata)
{
	uint8_t return_value;

	C2_WriteAR (sfraddress);
	if (NO_ERROR != (return_value = C2_WriteDR (sfrdata, C2_WRITE_DR_TIMEOUT_US)))
		return SFR_WRITE_TIMEOUT;
	return return_value;
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
uint8_t C2_WriteCommand (uint8_t command, uint16_t C2_poll_inbusy_timeout_ms)
{
	uint8_t return_value;

	// Send command
	if (NO_ERROR != (return_value = C2_WriteDR (command, C2_WRITE_DR_TIMEOUT_US)))
		return return_value;

	// verify acceptance
	return C2_Poll_InBusy (C2_poll_inbusy_timeout_ms);
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
uint8_t C2_ReadResponse (uint16_t C2_poll_outready_timeout_ms)
{
   uint8_t return_value;

   // check for response
   if (NO_ERROR != (return_value = C2_Poll_OutReady (C2_poll_outready_timeout_ms)))
		return return_value;
	// read status
	if (NO_ERROR != (return_value = C2_ReadDR (C2_READ_DR_TIMEOUT_US)))
		return return_value;

	if (C2_DR != COMMAND_OK)
		return ((C2_DR == C2_FPDAT_RETURN_INVALID_COMMAND) ? BAD_DEBUG_COMMAND : C2_DR);

	return NO_ERROR;
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
uint8_t C2_ReadData (uint16_t C2_poll_outready_timeout_ms)
{
	uint8_t return_value;

	// check for response
	if (NO_ERROR != (return_value = C2_Poll_OutReady (C2_poll_outready_timeout_ms)))
		return return_value;

	// read status
	return C2_ReadDR (C2_READ_DR_TIMEOUT_US);
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
uint8_t C2_ReadDirect (uint8_t sfraddress, uint8_t *sfrdata, uint8_t indirect)
{
	uint8_t return_value;

	C2_WriteAR (KNOWN_FAMILIES[FAMILY_NUMBER].FPDAT);

	// set up command accesses
	if (indirect == C2_DIRECT)
	{
		if (NO_ERROR != (return_value = C2_WriteCommand (C2_FPDAT_DIRECT_READ, C2_POLL_INBUSY_TIMEOUT_MS)))
			return return_value;
	}
	else
	{
		if (NO_ERROR != (return_value = C2_WriteCommand (C2_FPDAT_INDIRECT_READ, C2_POLL_INBUSY_TIMEOUT_MS)))
			return return_value;
	}

	// Check command status
	if (NO_ERROR != (return_value = C2_ReadResponse (C2_POLL_OUTREADY_TIMEOUT_MS)))
		return return_value;

	// now send address of byte to read
	if (NO_ERROR != (return_value = C2_WriteCommand (sfraddress, C2_POLL_INBUSY_TIMEOUT_MS)))
		return return_value;

	// Send number of bytes to read
	if (NO_ERROR != (return_value = C2_WriteCommand (1, C2_POLL_INBUSY_TIMEOUT_MS)))
		return return_value;

	// read the data
	if (NO_ERROR != (return_value = C2_ReadData (C2_POLL_OUTREADY_TIMEOUT_MS)))
		return return_value;

	*sfrdata = C2_DR;
	return return_value;
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
uint8_t C2_WriteDirect (uint8_t sfraddress, uint8_t sfrdata, uint8_t indirect)
{
	uint8_t return_value;

	// set up command accesses
	C2_WriteAR (KNOWN_FAMILIES[FAMILY_NUMBER].FPDAT);

	if (indirect == C2_DIRECT)
	{
		if (NO_ERROR != (return_value = C2_WriteCommand (C2_FPDAT_DIRECT_WRITE, C2_POLL_INBUSY_TIMEOUT_MS)))
			return return_value;
	}
	else
	{
		if (NO_ERROR != (return_value = C2_WriteCommand (C2_FPDAT_INDIRECT_WRITE, C2_POLL_INBUSY_TIMEOUT_MS)))
			return return_value;
	}

	// Check response
	if (NO_ERROR != (return_value = C2_ReadResponse (C2_POLL_OUTREADY_TIMEOUT_MS)))
		return return_value;

	// now send address of byte to write
	if (NO_ERROR != (return_value = C2_WriteCommand (sfraddress, C2_POLL_INBUSY_TIMEOUT_MS)))
		return return_value;

	// Send number of bytes to write
	if (NO_ERROR != (return_value = C2_WriteCommand (1, C2_POLL_INBUSY_TIMEOUT_MS)))
		return return_value;

	// Send the data
	return C2_WriteCommand (sfrdata, C2_POLL_INBUSY_TIMEOUT_MS);
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
uint8_t C2_Discover (uint16_t* deviceid, uint16_t* derid)
{
	uint8_t return_value;
	uint16_t devid;
	uint8_t family_number;
	uint8_t derivative_number;
	uint16_t derivativeid;
	const DEVICE_FAMILY *dfptr;
	const DERIVATIVE_ENTRY *deptr;

	return_value = C2_GetDevID (&devid);
	*deviceid = devid;
	if (return_value != NO_ERROR)
		return return_value;

	family_number = 0;
	FAMILY_FOUND = false;
	while (FAMILY_FOUND == false && KNOWN_FAMILIES[family_number].FAMILY_STRING != NULL)
	{
		if (devid == KNOWN_FAMILIES[family_number].DEVICE_ID)
		{
			FAMILY_FOUND = true;
			FAMILY_NUMBER = family_number;
			break;
		}
		family_number++;
	}

	if (FAMILY_FOUND == false)
		return FAMILY_NOT_SUPPORTED;

	dfptr = &KNOWN_FAMILIES[FAMILY_NUMBER];

	// Get derivative information
	C2_WriteAR (dfptr->FPDAT);
	if (NO_ERROR != (return_value = C2_WriteCommand (C2_FPDAT_GET_DERIVATIVE, C2_POLL_INBUSY_TIMEOUT_MS)))
		return return_value;

	if (NO_ERROR != (return_value = C2_ReadResponse (C2_POLL_OUTREADY_TIMEOUT_MS)))
		return return_value;

	// now read the derivative value
	if (NO_ERROR != (return_value = C2_ReadData (C2_POLL_OUTREADY_TIMEOUT_MS)))
		return return_value;

	derivativeid = (uint16_t) C2_DR;
	*derid = derivativeid;

	derivative_number = 0;
	DERIVATIVE_FOUND = false;
	deptr = &(dfptr->DERIVATIVE_LIST[0]);

	while (DERIVATIVE_FOUND == false && deptr->DERIVATIVE_STRING != NULL)
	{
		if (derivativeid == deptr->DERIVATIVE_ID)
		{
			DERIVATIVE_NUMBER = derivative_number;
			DERIVATIVE_FOUND = true;
			break;
		}
		else
		{
			derivative_number++;
			deptr = &(dfptr->DERIVATIVE_LIST[derivative_number]);
		}
	}

	if (DERIVATIVE_FOUND == false)
		return DERIVATIVE_NOT_SUPPORTED;

	return return_value;
}
