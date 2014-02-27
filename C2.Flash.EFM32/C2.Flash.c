/**************************************************************************//**
 * @file
 * @brief LEUART Demo Application
 * @version 1.08
 *****************************************************************************/
#include "em_device.h"
#include "em_chip.h"
#include "em_cmu.h"
#include "em_emu.h"
#include "em_leuart.h"
#include "em_gpio.h"
#include "bsp.h"

#define C2CK_PORT_GPIO	GPIO->P[gpioPortC]
#define C2CK_BIT		(1 << 0)
#define C2CK_MASK		_GPIO_P_MODEL_MODE0_MASK
#define C2CK_MODE_IN	GPIO_P_MODEL_MODE0_INPUTPULL
#define C2CK_MODE_OUT	GPIO_P_MODEL_MODE0_PUSHPULL
#define C2CK_PORT_MODE	C2CK_PORT_GPIO.MODEL

#define C2D_PORT_GPIO	GPIO->P[gpioPortC]
#define C2D_BIT			(1 << 1)
#define C2D_MASK		_GPIO_P_MODEL_MODE1_MASK
#define C2D_MODE_IN		GPIO_P_MODEL_MODE1_INPUT
#define C2D_MODE_OUT	GPIO_P_MODEL_MODE1_PUSHPULL
#define C2D_PORT_MODE	C2D_PORT_GPIO.MODEL

#define C2CK_PIN		C2CK_PORT_GPIO.DIN
#define C2CK_PORT		C2CK_PORT_GPIO.DOUT

#define C2D_PIN			C2D_PORT_GPIO.DIN
#define C2D_PORT		C2D_PORT_GPIO.DOUT

typedef uint8_t byte;

#define LED_OFF()		BSP_LedClear(0)
#define LED_ON()		BSP_LedSet(0)
#define LED2_ON()		BSP_LedSet(1)
#define LED2_OFF()		BSP_LedClear(1)

#define GetHostChar()	LEUART_Rx(LEUART0)
#define PutHostChar(ch)	LEUART_Tx(LEUART0, ch)
#define cli()			__disable_irq()
#define sei()			__enable_irq()

// DeviceID definitions
#define C8051F32X_DEVICEID		0x09
#define SI100X_DEVICEID			0x16

// C2 Host command
#define C2_CONNECT_TARGET       0x20
#define C2_DISCONNECT_TARGET    0x21
#define C2_DEVICE_ID            0x22
#define C2_UNIQUE_DEVICE_ID     0x23
#define C2_TARGET_GO            0x24
#define C2_TARGET_HALT          0x25

#define C2_READ_SFR             0x28
#define C2_WRITE_SFR            0x29
#define C2_READ_RAM             0x2A
#define C2_WRITE_RAM            0x2B
#define C2_READ_FLASH           0x2E
#define C2_WRITE_FLASH          0x2F
#define C2_ERASE_PAGE           0x30

#define C2_ADDRESSWRITE         0x38
#define C2_ADDRESSREAD          0x39
#define C2_DATAWRITE            0x3A
#define C2_DATAREAD             0x3B

#define C2_ERASE_FLASH_03       0x3C
#define C2_ERASE_FLASH_04       0x3D
#define C2_READ_XRAM            0x3E
#define C2_WRITE_XRAM           0x3F

#define GET_FIRMWARE_VERSION	0x44
#define SET_FPDAT_ADDRESS		0x45
#define GET_FPDAT_ADDRESS		0x46

// C2 status return codes
#define COMMAND_INVALID			0x00
#define COMMAND_NO_CONNECT		0x01
#define COMMAND_FAILED			0x02
#define COMMAND_TIMEOUT			0x04
#define COMMAND_BAD_DATA		0x05
#define COMMAND_OK				0x0D
#define COMMAND_READ_01			0x81
#define COMMAND_READ_02			0x82
#define COMMAND_READ_03			0x83
#define COMMAND_READ_04			0x84

// C2 FP Command
#define C2_FP_ERASE_DEVICE		0x03
#define C2_FP_READ_FLASH		0x06
#define C2_FP_WRITE_FLASH		0x07
#define C2_FP_ERASE_SECTOR		0x08

#define C2_FP_READ_XRAM			0x0E
#define C2_FP_WRITE_XRAM		0x0F

#define C2ADD_OUTREADY	0x01
#define C2ADD_INBUSY	0x02

#define C2ADD_DEVICEID	0
#define C2ADD_REVISION	1
#define C2ADD_FPCTL		2
byte	C2ADD_FPDAT		= 0xB4;

byte DeviceID		= 0;
byte C2_CONNECTED	= 0;
byte C2_RESPONSE	= 0;

byte cmdPackage[140];
byte cmdPackageLength;
byte cmdPackageGet;

/**************************************************************************//**
 * @brief SysTick_Handler
 * Interrupt Service Routine for system tick counter
 *****************************************************************************/
void delayMicroseconds(volatile uint16_t usecs)
{
	while (usecs-- != 0)
	{
		__NOP();
		__NOP();
		__NOP();
		__NOP();
	}
}

volatile uint32_t msTicks; /* counts 1ms timeTicks */
volatile uint16_t msDelay;

/**************************************************************************//**
 * @brief SysTick_Handler
 * Interrupt Service Routine for system tick counter
 *****************************************************************************/
void SysTick_Handler(void)
{
	msTicks++;       /* increment counter necessary in Delay()*/
	if (msDelay != 0)
		msDelay--;
}

/**************************************************************************//**
 * @brief Delays number of msTick Systicks (typically 1 ms)
 * @param dlyTicks Number of ticks to delay
 *****************************************************************************/
void delay(uint16_t dlyTicks)
{
	msDelay = 1;
	while (msDelay != 0);
	msDelay = dlyTicks;
	while (msDelay != 0);
}

unsigned long millis(void)
{
	return msTicks;
}
/**************************************************************************//**
 * @brief  Initialize Low Energy UART 1
 *
 * Here the LEUART is initialized with the chosen settings. It is then routed
 * to location 0 to avoid conflict with the LCD pinout. Finally the GPIO mode
 * is set to push pull.
 *
 *****************************************************************************/
/* Defining the LEUART0 initialization data */
const LEUART_Init_TypeDef leuartInit =
{
	leuartEnable,
	0,                    /* Inherit the clock frequenzy from the LEUART clock source */
	115200,
	leuartDatabits8,
	leuartNoParity,
	leuartStopbits2,      /* Setting the number of stop bits in a frame to 2 bitperiods */
};

void InitLEUART(void)
{
	LEUART_Reset(LEUART0);
	LEUART_Init(LEUART0, &leuartInit);

	LEUART0->ROUTE = LEUART_ROUTE_TXPEN | LEUART_ROUTE_RXPEN | LEUART_ROUTE_LOCATION_LOC0;

	GPIO_PinModeSet(gpioPortD, 4, gpioModePushPull, 1);		/* Enable GPIO for LEUART0. TX is on D4 */
	GPIO_PinModeSet(gpioPortD, 5, gpioModeInputPull, 1);	/* Enable GPIO for LEUAR0.  RX is on D5 */
}

void SendChar(char ch)
{
	if (ch == '\r')
		LEUART_Tx(LEUART0, '\n');
	LEUART_Tx(LEUART0, ch);
}

void SendString(const char *src)
{
	char ch;
	while ((ch = *src++) != 0)
	{
		SendChar(ch);
	}
}

/**************************************************************************//**
 * @brief  char2hex
 *
 *****************************************************************************/
byte char2hex(char c)
{
	if (c >= '0' && c <= '9')
		return (c - '0');
	if (c >= 'A' && c <= 'F')
		return (c - 'A' + 0xA);
	if (c >= 'a' && c <= 'f')
		return (c - 'a' + 0xA);
	C2_RESPONSE = COMMAND_BAD_DATA;
	return 0;
}

/**************************************************************************//**
 * @brief  GetNextByte_Cmd
 *
 *****************************************************************************/
byte GetNextByte()
{
	byte data = 0;
	if (cmdPackageGet < cmdPackageLength)
		data = cmdPackage[cmdPackageGet++];
	else
		C2_RESPONSE = COMMAND_BAD_DATA;
	return data;
}

/**************************************************************************//**
 * @brief  GetNextByte_Cmd
 *
 *****************************************************************************/
byte GetNextByte_Cmd()
{
	byte state = 0;
	byte c;
	byte command;

	C2_RESPONSE = COMMAND_BAD_DATA;

	for (;;)
	{
		c = GetHostChar();
		if (c == '^')
		{
			// Package start symbol, initialize package variables
			cmdPackageLength = 0;
			C2_RESPONSE = COMMAND_INVALID;
			state = 1;
		}
		else if (state == 1)
		{
			if (c == '$')
				break;

			command = char2hex(c) << 4;
			state++;
		}
		else if (state == 2)
		{
			if (c == '$')
			{
				C2_RESPONSE = COMMAND_BAD_DATA;
				break;
			}
			command |= char2hex(c);
			if (cmdPackageLength >= sizeof(cmdPackage))
			{
				state++;
				C2_RESPONSE = COMMAND_BAD_DATA;
			}
			else
			{
				cmdPackage[cmdPackageLength++] = command;
				state--;
			}
		}
		else if (state == 3 && c == '$')
			break;
	}

	// Minimum package
	// command  - 1 byte
	// checksum - 1 byte
	command = 0;
	if (cmdPackageLength < 2)
		C2_RESPONSE = COMMAND_BAD_DATA;
	else
	{
		for (c = 0; c < cmdPackageLength; c++)
			command += cmdPackage[c];

		if (command)
			C2_RESPONSE = COMMAND_BAD_DATA;

		--cmdPackageLength;			// Last byte = checksum
		cmdPackageGet = 0;			// Pointer to data
		command = GetNextByte();	// First byte = command
	}
	return command;
}

void hex2char(byte data)
{
	if (data >= 0x0A)
		PutHostChar(data + ('A' - 0x0A));
	else
		PutHostChar(data + '0');
}

void PutByte(byte data)
{
	hex2char((data >> 4) & 0x0F);
	hex2char(data & 0x0F);
}

/**************************************************************************//**
 * @brief	
 *
 *****************************************************************************/
void C2CK_DriverOn(void)
{
	C2CK_PORT |=  C2CK_BIT;
	C2CK_PORT_MODE = (C2CK_PORT_MODE & ~C2CK_MASK) | C2CK_MODE_OUT;
}
void C2CK_DriverOff(void)
{
	C2CK_PORT |=  C2CK_BIT;
	C2CK_PORT_MODE = (C2CK_PORT_MODE & ~C2CK_MASK) | C2CK_MODE_IN;
}

/**************************************************************************//**
 * @brief	
 *
 *****************************************************************************/
void C2D_DriverOn(void)
{
	C2D_PORT &= ~C2D_BIT;
	C2D_PORT_MODE = (C2D_PORT_MODE & ~C2D_MASK) | C2D_MODE_OUT;
}

/**************************************************************************//**
 * @brief	
 *
 *****************************************************************************/
void C2D_DriverOff()
{
	C2D_PORT_MODE = (C2D_PORT_MODE & ~C2D_MASK) | C2D_MODE_IN;
}

/**************************************************************************//**
 * @brief	
 *
 *****************************************************************************/
void C2_Reset(void)
{
	cli();
	C2CK_DriverOn();
	C2CK_PORT &= ~C2CK_BIT;
	delayMicroseconds(30);
	C2CK_PORT |= C2CK_BIT;
	delayMicroseconds(5);
	sei();
	C2_RESPONSE = COMMAND_OK;
}

/**************************************************************************//**
 * @brief	
 *
 *****************************************************************************/
void Pulse_C2CLK(void)
{
	C2CK_PORT &= ~C2CK_BIT;
	C2CK_PORT |= C2CK_BIT;
}

/**************************************************************************//**
 * @brief	
 *
 *****************************************************************************/
void C2_SendByte(byte data)
{
	byte mask;
	for (mask = 0x01; mask != 0; mask <<= 1)
	{
		if (data & mask)
		{
			C2D_PORT |= C2D_BIT;
		}
		else
		{
			C2D_PORT &= ~C2D_BIT;
		}
		Pulse_C2CLK();
	}
}

/**************************************************************************//**
 * @brief	
 *
 *****************************************************************************/
void C2_WriteAR(byte addr)
{
	cli();

	// START field
	Pulse_C2CLK();

	C2D_DriverOn();
	// INS field (11b, LSB first)
	C2D_PORT |= C2D_BIT;
	Pulse_C2CLK();
	Pulse_C2CLK();

	// ADDRESS field
	C2_SendByte(addr);

	// STOP field
	C2D_DriverOff();
	Pulse_C2CLK();
	sei();

	C2_RESPONSE = COMMAND_OK;
	return;
}

/**************************************************************************//**
 * @brief	
 *
 *****************************************************************************/
byte C2_WriteDR(byte data)
{
	int retry;

	cli();

	// START field
	Pulse_C2CLK();

	C2D_DriverOn();
	// INS field (01b, LSB first)
	C2D_PORT |= C2D_BIT;
	Pulse_C2CLK();
	C2D_PORT &= ~C2D_BIT;
	Pulse_C2CLK();

	// LENGTH field (00b -> 1 byte)
	Pulse_C2CLK();
	Pulse_C2CLK();

	// DATA field
	C2_SendByte(data);

	C2D_DriverOff();
	retry = 100;
	do
	{
		Pulse_C2CLK();
		if (C2D_PIN & C2D_BIT)
			break;
		delayMicroseconds(1);
	} while (retry-- != 0);

	// STOP field
	Pulse_C2CLK();

	sei();

	C2_RESPONSE = (retry ? COMMAND_OK : COMMAND_TIMEOUT);
	return C2_RESPONSE;
}

/**************************************************************************//**
 * @brief  Set_Connected_And_LEDs
 *
 *****************************************************************************/
void Set_Connected_And_LEDs()
{
	C2_CONNECTED = 1;
	LED2_ON();
}

/**************************************************************************//**
 * @brief  Prepare_C2_Device_Params
 *
 *****************************************************************************/
void Prepare_C2_Device_Params()
{
	if (DeviceID == C8051F32X_DEVICEID || DeviceID == SI100X_DEVICEID)
		C2ADD_FPDAT = 0xB4;
	else
		C2ADD_FPDAT = 0xAD;
}

/**************************************************************************//**
 * @brief  C2_ReadDR
 *
 *****************************************************************************/
byte C2_ReadDR()
{
	int retry;
	byte mask;
	byte data = 0;

	cli();
	// START field
	Pulse_C2CLK();

	C2D_DriverOn();
	C2D_PORT &= ~C2D_BIT;

	Pulse_C2CLK();		// INS field (00b, LSB first)
	Pulse_C2CLK();

	Pulse_C2CLK();		// LENGTH field (00b -> 1 byte)
	Pulse_C2CLK();

	// WAIT field
	C2D_DriverOff();	// Disable C2D driver for input
	retry = 100;
	do
	{
		Pulse_C2CLK();
		if (C2D_PIN & C2D_BIT)
			break;
		delayMicroseconds(1);
	} while (retry-- != 0);

	if (retry)
	{
		// DATA field
		for (mask = 0x01; mask != 0; mask <<= 1)
		{
			Pulse_C2CLK();
			if (C2D_PIN & C2D_BIT)
				data |= mask;
		}

		// STOP field
		Pulse_C2CLK();
	}

	sei();

	C2_RESPONSE = (retry ? COMMAND_OK : COMMAND_TIMEOUT);
	return data;
}

/**************************************************************************//**
 * @brief  C2_ReadAR
 *
 *****************************************************************************/
byte C2_ReadAR()
{
	byte mask;
	byte data = 0;

	cli();

	// START field
	Pulse_C2CLK();

	C2D_DriverOn();
	// INS field (10b, LSB first)
	C2D_PORT &= ~C2D_BIT;
	Pulse_C2CLK();
	C2D_PORT |= C2D_BIT;
	Pulse_C2CLK();

	C2D_DriverOff();
	// ADDRESS field
	for (mask = 0x01; mask != 0; mask <<= 1)
	{
		Pulse_C2CLK();
		if (C2D_PIN & C2D_BIT)
			data |= mask;
	}

	// STOP field
	Pulse_C2CLK();
	sei();

	C2_RESPONSE = COMMAND_OK;
	return data;
}

/**************************************************************************//**
 * @brief  Poll_OutReady
 *
 *****************************************************************************/
byte Poll_OutReady()
{
	int timeout = 500;
	C2_RESPONSE = COMMAND_OK;
	while (!(C2_ReadAR() & C2ADD_OUTREADY))
	{
		if (--timeout == 0)
		{
			C2_RESPONSE = COMMAND_TIMEOUT;
			break;
		}
		delayMicroseconds(1);
	}
	return C2_RESPONSE;
}

/**************************************************************************//**
 * @brief  Poll_InBusy
 *
 *****************************************************************************/
byte Poll_InBusy()
{
	int timeout = 500;
	C2_RESPONSE = COMMAND_OK;
	while ((C2_ReadAR() & C2ADD_INBUSY))
	{
		if (--timeout == 0)
		{
			C2_RESPONSE = COMMAND_TIMEOUT;
			break;
		}
		delayMicroseconds(1);
	}
	return C2_RESPONSE;
}

/**************************************************************************//**
 * @brief  C2_Read_FPDAT
 *
 *****************************************************************************/
byte C2_Read_FPDAT()
{
	if (Poll_OutReady() == COMMAND_OK)
	{
		C2_WriteAR(C2ADD_FPDAT);
		return C2_ReadDR();
	}
	return 0;
}

/**************************************************************************//**
 * @brief  C2_Write_FPDAT
 *
 *****************************************************************************/
byte C2_Write_FPDAT(byte data)
{
	C2_WriteAR(C2ADD_FPDAT);
	if (C2_WriteDR(data) == COMMAND_OK)
	{
		int timeout = 1000;
		while (C2_ReadAR() & C2ADD_INBUSY)
		{
			if (--timeout == 0)
			{
				C2_RESPONSE = COMMAND_TIMEOUT;
				break;
			}
			delayMicroseconds(1);
		}
	}
	return C2_RESPONSE;
}

/**************************************************************************//**
 * @brief  C2_Write_FPDAT_Read
 *
 *****************************************************************************/
byte C2_Write_FPDAT_Read(byte data)
{
	if (C2_Write_FPDAT(data) == COMMAND_OK)
		return C2_Read_FPDAT();
	return 0;
}

/**************************************************************************//**
 * @brief  C2_Connect_Target
 *
 *****************************************************************************/
void C2_Connect_Target()
{
	C2_Reset();
	C2_WriteAR(C2ADD_FPCTL);
	C2_WriteDR(0x02);
	C2_WriteDR(0x04);
	delayMicroseconds(30);
	C2_WriteDR(0x01);
	delay(20);
	C2_WriteAR(C2ADD_DEVICEID);
	DeviceID = C2_ReadDR();

	Prepare_C2_Device_Params();
	Set_Connected_And_LEDs();
}

/**************************************************************************//**
 * @brief  C2_Disconnect_Target
 *
 *****************************************************************************/
byte C2_Disconnect_Target()
{
	C2_WriteAR(C2ADD_FPCTL);
	C2_WriteDR(0x00);
	delayMicroseconds(40);
	C2_Reset();
	C2_CONNECTED = 0;
	LED2_OFF();
	return COMMAND_OK;
}

/**************************************************************************//**
 * @brief  C2_Device_ID
 *
 *****************************************************************************/
void C2_Device_ID()
{
	C2_WriteAR(C2ADD_DEVICEID);
	PutByte(C2_ReadDR());

	C2_WriteAR(C2ADD_REVISION);
	PutByte(C2_ReadDR());
}

/**************************************************************************//**
 * @brief  C2_Unique_Device_ID
 *
 *****************************************************************************/
void C2_Unique_Device_ID()
{
	byte id1 = 0;
	byte id2 = 0;
	C2_RESPONSE = COMMAND_NO_CONNECT;
	if (C2_CONNECTED)
	{
		if (C2_Write_FPDAT_Read(0x01) == COMMAND_OK)
		{
			id1 = C2_Read_FPDAT();
			if (C2_RESPONSE == COMMAND_OK)
			{
				if (C2_Write_FPDAT_Read(0x02) == COMMAND_OK)
					id2 = C2_Read_FPDAT();
			}
		}
	}
	PutByte(id1);
	PutByte(id2);
}

/**************************************************************************//**
 * @brief  C2_Target_Go
 *
 *****************************************************************************/
void C2_Target_Go()
{
	C2_RESPONSE = COMMAND_OK;
	if (C2_CONNECTED)
	{
		C2_WriteAR(C2ADD_FPCTL);
		if (C2_WriteDR(0x08) == COMMAND_OK)
		{
			C2CK_DriverOff();
			C2_CONNECTED = 0;
			LED2_OFF();
		}
	}
}

/**************************************************************************//**
 * @brief  C2_Target_Halt
 *
 *****************************************************************************/
void C2_Target_Halt()
{
	uint32_t timeout;

	C2_RESPONSE = COMMAND_OK;
	if (!C2_CONNECTED)
	{
		if (C2CK_PIN & C2CK_BIT)
		{
			cli();
			C2CK_DriverOn();
			C2CK_PORT &= ~C2CK_BIT;
			delayMicroseconds(1);
			C2CK_DriverOff();
			sei();
		}
		timeout = millis();
		while (!(C2CK_PIN & C2CK_BIT))
		{
			if (millis() - timeout > 1000)
			{
				C2_RESPONSE = COMMAND_FAILED;
				return;
			}
		}
		C2CK_DriverOn();
		Set_Connected_And_LEDs();
		return;
	}
	LED2_OFF();
}

void C2_Erase_Flash_03(void)
{
	byte data;

	C2_RESPONSE = COMMAND_NO_CONNECT;
	if (!C2_CONNECTED)
		return;

	C2_WriteAR(0xFF);
	C2_WriteDR(0x80);

	C2_WriteAR(0xEF);
	C2_WriteDR(0x02);

	C2_WriteAR(C2ADD_FPCTL);
	C2_WriteDR(0x02);
	C2_WriteDR(0x01);

	delay(25);

	C2_WriteAR(C2ADD_FPDAT);

	if (C2_WriteDR(0x03) != COMMAND_OK)
	{
		PutByte(0x51);
	}
	else if (Poll_InBusy() != COMMAND_OK)
	{
		PutByte(0x52);
	}
	else if (Poll_OutReady() != COMMAND_OK)
	{
		PutByte(0x53);
	}
	else
	{
		data = C2_ReadDR();
		if (C2_RESPONSE != COMMAND_OK)
		{
			PutByte(0x54);
		}
//		else if (data != COMMAND_OK)
//		{
//			PutByte(0x55);
//			PutByte(data);
//		}
		else if (C2_WriteDR(0xDE) != COMMAND_OK)
		{
			PutByte(0x56);
		}
		else if (Poll_InBusy() != COMMAND_OK)
		{
			PutByte(0x57);
		}
		else if (C2_WriteDR(0xAD) != COMMAND_OK)
		{
			PutByte(0x58);
		}
		else if (Poll_InBusy() != COMMAND_OK)
		{
			PutByte(0x59);
		}
		else if (C2_WriteDR(0xA5) != COMMAND_OK)
		{
			PutByte(0x5A);
		}
		else if (Poll_InBusy() != COMMAND_OK)
		{
			PutByte(0x5B);
		}
		else if (Poll_OutReady() != COMMAND_OK)
		{
			PutByte(0x5C);
		}
		else
		{
			data = C2_ReadDR();
			if (C2_RESPONSE != COMMAND_OK)
			{
				PutByte(0x5D);
			}
			else if (data != COMMAND_OK)
			{
				PutByte(0x5E);
				PutByte(data);
			}
		}
	}
}

/**************************************************************************//**
 * @brief  C2_Erase_Flash_04
 *
 *****************************************************************************/
void C2_Erase_Flash_04(void)
{
	byte data;
	C2_RESPONSE = COMMAND_NO_CONNECT;
	if (C2_CONNECTED)
		if ((data = C2_Write_FPDAT_Read(0x04)) != COMMAND_OK)
			C2_RESPONSE = data;
		else if ((data = C2_Write_FPDAT(0xDE)) != COMMAND_OK)
			C2_RESPONSE = data;
		else if ((data = C2_Write_FPDAT(0xAD)) != COMMAND_OK)
			C2_RESPONSE = data;
		else if ((data = C2_Write_FPDAT(0xA5)) != COMMAND_OK)
			C2_RESPONSE = data;
		else
			C2_RESPONSE = C2_Read_FPDAT();
}

/**************************************************************************//**
 * @brief  C2_Erase_Flash_Sector
 *
 *****************************************************************************/
void C2_Erase_Flash_Sector(void)
{
	byte sector = GetNextByte();
	if (C2_RESPONSE == COMMAND_BAD_DATA)
		return;

	C2_RESPONSE = COMMAND_NO_CONNECT;
	for (;;)
	{
		if (!C2_CONNECTED)
			break;
		if (C2_Write_FPDAT_Read(C2_FP_ERASE_SECTOR) != COMMAND_OK)
			break;
		if (C2_Write_FPDAT_Read(sector) != COMMAND_OK)
			break;
		C2_Write_FPDAT(0);
		break;
	}
}

/**************************************************************************//**
 * @brief  Main function
 *
 * Read Memory
 *	06, read flash
 *	09, read SFR
 *	0B, read RAM
 *	0E, read XRAM
 * Return:
 *	0xD
 * 
 *****************************************************************************/
void C2_Read_Memory(byte memType)
{
	byte data;
	byte address16bit = (memType == C2_FP_READ_XRAM || memType == C2_FP_READ_FLASH ? 1 : 0);
	byte lowAddress = GetNextByte();
	byte highAddress = 0;
	byte byteCount;

	if (address16bit)
		highAddress = GetNextByte();
	byteCount = GetNextByte();

	if (C2_RESPONSE == COMMAND_BAD_DATA)
		return;

	C2_RESPONSE = COMMAND_NO_CONNECT;
	for (;;)
	{
		if (!C2_CONNECTED)
			break;

		// Write FP Command
		data = C2_Write_FPDAT_Read(memType);
		if (data != COMMAND_OK)
		{
			PutByte(data);
			C2_RESPONSE = COMMAND_READ_01;
			break;
		}

		// Write high address for Flash and XRAM
		if (address16bit)
		{
			data = C2_Write_FPDAT(highAddress);
			if (data != COMMAND_OK)
			{
				PutByte(data);
				C2_RESPONSE = COMMAND_READ_02;
				break;
			}
		}

		// Write low address
		data = C2_Write_FPDAT(lowAddress);
		if (data != COMMAND_OK)
		{
			PutByte(data);
			C2_RESPONSE = COMMAND_READ_03;
			break;
		}

		// Write byte count
		data = C2_Write_FPDAT(byteCount);
		if (data != COMMAND_OK)
		{
			PutByte(data);
			C2_RESPONSE = COMMAND_READ_04;
			break;
		}

		// Read response only for Flash
		if (memType == C2_FP_READ_FLASH)
		{
			C2_RESPONSE = C2_Read_FPDAT();
			if (C2_RESPONSE != COMMAND_OK)
				break;
		}

		// Read data to host
		for (; byteCount; byteCount--)
		{
			data = C2_Read_FPDAT();
			if (C2_RESPONSE != COMMAND_OK)
				break;
			PutByte(data);
		}
		break;
	}
}

/**************************************************************************//**
 * @brief  Main function
 *
 *****************************************************************************/
byte ContainData_Q040(byte count)
{
	if ((cmdPackageLength - cmdPackageGet) == count)
		return 1;
	C2_RESPONSE = COMMAND_BAD_DATA;
	return 0;
}

/**************************************************************************//**
 * @brief  Main function
 *
 *	Write Memory
 *		07, write to flash
 *		0A, write to SFR
 *		0C, write to RAM
 *		0F, write to XRAM
 *	Return:
 *		0xD
 * 
 *****************************************************************************/
void C2_Write_Memory(byte memType)
{
	byte byteCount;
	byte address16bit = (memType == C2_FP_WRITE_XRAM || memType == C2_FP_WRITE_FLASH ? 1 : 0);
	byte lowAddress = GetNextByte();
	byte highAddress = 0;
	if (address16bit)
		highAddress = GetNextByte();
	byteCount = GetNextByte();

	if ((C2_RESPONSE == COMMAND_BAD_DATA) || !ContainData_Q040(byteCount))
		return;

	C2_RESPONSE = COMMAND_NO_CONNECT;
	for (;;)
	{
		if (!C2_CONNECTED)
			break;

		if (C2_Write_FPDAT_Read(memType) != COMMAND_OK)
			break;

		if (address16bit)
			if (C2_Write_FPDAT(highAddress) != COMMAND_OK)
				break;

		if (C2_Write_FPDAT(lowAddress) != COMMAND_OK)
			break;

		if (C2_Write_FPDAT(byteCount) != COMMAND_OK)
			break;

		if (memType == C2_FP_WRITE_FLASH)
			if (C2_Read_FPDAT() != COMMAND_OK)
				break;

		for (; byteCount; byteCount--)
			if (C2_Write_FPDAT(GetNextByte()) != COMMAND_OK)
				break;

		if (C2_RESPONSE == COMMAND_OK)
			Poll_OutReady();

		break;
	}
}

/**************************************************************************//**
 * @brief
 *
 *****************************************************************************/
void Get_Firmware_Version()
{
	PutByte(0x44);
	PutByte(0x06);
	C2_RESPONSE = COMMAND_OK;
}

/**************************************************************************//**
 * @brief
 *
 *****************************************************************************/
void Get_FPDAT_Address()
{
	PutByte(C2ADD_FPDAT);
	C2_RESPONSE = COMMAND_OK;
}

void Set_FPDAT_Address()
{
	C2ADD_FPDAT = GetNextByte();
	if (C2_RESPONSE == COMMAND_BAD_DATA)
		return;
	C2_RESPONSE = COMMAND_OK;
}

/**************************************************************************//**
 * @brief  Main function
 *
 *****************************************************************************/
int main(void)
{
	CHIP_Init();

	CMU_ClockSelectSet(cmuClock_HF, cmuSelect_HFXO);
	CMU_ClockSelectSet(cmuClock_LFB, cmuSelect_CORELEDIV2);

	/* Enabling clocks, all other remain disabled */
	CMU_ClockEnable(cmuClock_GPIO, true);       /* Enable GPIO clock */

	BSP_LedsInit();

	if (SysTick_Config(CMU_ClockFreqGet(cmuClock_CORE) / 1000))
	{	// SysTick failure, light all LEDs
		BSP_LedsSet(0xF);
		while (1) ;
	}

	CMU_ClockEnable(cmuClock_CORELE, true);     /* Enable CORELE clock */
	CMU_ClockEnable(cmuClock_LEUART0, true);    /* Enable LEUART0 clock */
	InitLEUART();

	// SendString("\rSilabs C2 Flash\r");
	while (1)
	{
		byte cmd = GetNextByte_Cmd();
		LED_ON();
		PutHostChar('^');
		if (C2_RESPONSE == COMMAND_INVALID)
		{
			switch(cmd)
			{
			case C2_CONNECT_TARGET:
				C2_Connect_Target();
				break;
			case C2_DISCONNECT_TARGET:
				C2_Disconnect_Target();
				break;
			case C2_DEVICE_ID:
				C2_Device_ID();
				break;
			case C2_UNIQUE_DEVICE_ID:
				C2_Unique_Device_ID();
				break;
			case C2_TARGET_GO:
				C2_Target_Go();
				break;
			case C2_TARGET_HALT:
				C2_Target_Halt();
				break;
			case C2_ADDRESSWRITE:
				cmd = GetNextByte();
				if (C2_RESPONSE != COMMAND_BAD_DATA)
					C2_WriteAR(cmd);
				break;
			case C2_ADDRESSREAD:
				PutByte(C2_ReadAR());
				break;
			case C2_DATAWRITE:
				cmd = GetNextByte();
				if (C2_RESPONSE != COMMAND_BAD_DATA)
					C2_WriteDR(cmd);
				break;
			case C2_DATAREAD:
				PutByte(C2_ReadDR());
				break;
			case C2_ERASE_FLASH_03:
				C2_Erase_Flash_03();
				break;
			case C2_ERASE_FLASH_04:
				C2_Erase_Flash_04();
				break;
			case C2_ERASE_PAGE:
				C2_Erase_Flash_Sector();
				break;
			case C2_READ_SFR:
				C2_Read_Memory(0x9);
				break;
			case C2_WRITE_SFR:
				C2_Write_Memory(0xA);
				break;
			case C2_READ_RAM:
				C2_Read_Memory(0xB);
				break;
			case C2_WRITE_RAM:
				C2_Write_Memory(0xC);
				break;
			case C2_READ_FLASH:
				C2_Read_Memory(C2_FP_READ_FLASH);
				break;
			case C2_WRITE_FLASH:
				C2_Write_Memory(C2_FP_WRITE_FLASH);
				break;
			case C2_READ_XRAM:
				C2_Read_Memory(C2_FP_READ_XRAM);
				break;
			case C2_WRITE_XRAM:
				C2_Write_Memory(C2_FP_WRITE_XRAM);
				break;

			case GET_FIRMWARE_VERSION:
				Get_Firmware_Version();
				break;
			case SET_FPDAT_ADDRESS:
				Set_FPDAT_Address();
				break;
			case GET_FPDAT_ADDRESS:
				Get_FPDAT_Address();
				break;
			}
		}
		PutHostChar('$');
		PutByte(C2_RESPONSE);
		LED_OFF();
	}
}
