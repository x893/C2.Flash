// Connection   Arduino		Atmel
// C2CK         D5          PortD 5
// C2D          D5          PortD 6
// LED          D9          PortB 1

// Use low level access for speed
#define C2CK_BIT	_BV(5)
#define C2CK_PORT	PORTD
#define C2CK_PIN	PIND
#define C2CK_DDR	DDRD

#define C2D_BIT		_BV(6)
#define C2D_PORT	PORTD
#define C2D_PIN		PIND
#define C2D_DDR		DDRD

// Comment next line to disable LED
#define LED_BIT		_BV(1)
#define LED_PORT	PORTB
#define LED_PIN		PINB
#define LED_DDR		DDRB

#ifdef LED_BIT
	#define LED_ON()	(LED_PORT |= LED_BIT)
	#define LED_OFF()	(LED_PORT &= ~LED_BIT)
#else
	#define LED_ON()
	#define LED_OFF()
#endif

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
byte	C2ADD_FPDAT		= 0xAD;

byte DeviceID		= 0;
byte C2_CONNECTED	= 0;
byte LEDS_STATE		= 0;
byte C2_RESPONSE	= 0;

byte cmdPackage[140];
byte cmdPackageLength;
byte cmdPackageGet;

void setup()
{
	LED_DDR |= LED_BIT;
	LED_OFF();

	C2CK_DriverOn();
	C2D_DriverOff();

	Serial.begin(115200);
        Serial.println("C2 Flash");
	BlinkLED(5);
}

void loop()
{
	byte cmd = GetNextByte_Cmd();

	LED_ON();

	Serial.write('^');
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
	Serial.write('$');
	PutByte(C2_RESPONSE);

	LED_OFF();
}

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

byte ContainData_Q040(byte count)
{
	if ((cmdPackageLength - cmdPackageGet) == count)
		return 1;
	C2_RESPONSE = COMMAND_BAD_DATA;
	return 0;
}

byte GetNextByte()
{
	byte data = 0;
	if (cmdPackageGet < cmdPackageLength)
		data = cmdPackage[cmdPackageGet++];
	else
		C2_RESPONSE = COMMAND_BAD_DATA;
	return data;
}

byte GetNextByte_Cmd()
{
	byte state = 0;
	byte c;
	byte command;

	C2_RESPONSE = COMMAND_BAD_DATA;

	for (;;)
	{
		LED_OFF();
		unsigned int timer = 0;
		while (!Serial.available())
		{
			if (timer == 60500)
			{
				LED_OFF();
				timer = 0;
			}
			else if (timer == 60000)
			{
				LED_ON();
			}
			timer++;
		}
		LED_OFF();

		c = Serial.read();

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

/*******************************************************
 * 
 * Connect Target
 * Return:
 * 0x0D
 * 
 *******************************************************/
void C2_Connect_Target()
{
	C2_Reset();
	C2_WriteAR(C2ADD_FPCTL);
	if (C2_WriteDR(0x02) == COMMAND_OK)
	{
		if (C2_WriteDR(0x04) == COMMAND_OK)
		{
			delayMicroseconds(80);
			if (C2_WriteDR(0x01) == COMMAND_OK)
			{
				delay(25);

				C2_WriteAR(0x00);
				DeviceID = C2_ReadDR();

				Prepare_C2_Device_Params();
				Set_Connected_And_LEDs();
			}
		}
	}
}

void Prepare_C2_Device_Params()
{
	if (DeviceID == C8051F32X_DEVICEID || DeviceID == SI100X_DEVICEID)
		C2ADD_FPDAT = 0xB4;
	else
		C2ADD_FPDAT = 0xAD;
}

void Set_Connected_And_LEDs()
{
	C2_CONNECTED = 1;
	LEDS_STATE = 2;
}

/*******************************************************
 * 
 * Disconnect Target
 * Return:
 * 0x0D
 * 
 *******************************************************/
byte C2_Disconnect_Target()
{
	C2_WriteAR(C2ADD_FPCTL);
	C2_WriteDR(0x00);
	delayMicroseconds(40);
	C2_Reset();
	C2_CONNECTED = 0;
	LEDS_STATE = 0;
	return COMMAND_OK;
}

/*******************************************************
 * 
 * Get Device ID and Revision
 * Return:
 *	DeviceID
 *	Revision
 *	0x0D
 * 
 *******************************************************/
void C2_Device_ID()
{
	C2_WriteAR(C2ADD_DEVICEID);
	PutByte(C2_ReadDR());

	C2_WriteAR(C2ADD_REVISION);
	PutByte(C2_ReadDR());
}

/*******************************************************
 * 
 * Get Unique Device ID
 * Return:
 *	Unique Device ID 1
 *	Unique Device ID 1
 *	0x0D
 * 
 *******************************************************/
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

/*******************************************************
 * 
 * Target Go
 * Return:
 *	1		not connected
 *	0x0D go
 * 
 *******************************************************/
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
			LEDS_STATE = 1;
		}
	}
}

/*******************************************************
 * 
 * Target Halt
 * Return:
 *	0x0D
 * 
 *******************************************************/
void C2_Target_Halt()
{
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
		unsigned long timeout = millis();
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
	}
}

/*******************************************************
 * 
 * Erase Entire Flash (command 03)
 * Return:
 *	 0x0D
 * 
 *******************************************************/
void C2_Erase_Flash_03()
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

	delay(20);

	while (1)
	{
		C2_WriteAR(C2ADD_FPDAT);

		if (C2_WriteDR(0x03) != COMMAND_OK)
		{
			PutByte(0x51);
			break;
		}
		if (Poll_InBusy() != COMMAND_OK)
		{
			PutByte(0x52);
			break;
		}
		if (Poll_OutReady() != COMMAND_OK)
		{
			PutByte(0x53);
			break;
		}
		data = C2_ReadDR();
		if (C2_RESPONSE != COMMAND_OK)
		{
			PutByte(0x54);
			break;
		}
//		if (data != COMMAND_OK)
//		{
//			PutByte(0x55);
//			PutByte(data);
//			break;
//		}

		if (C2_WriteDR(0xDE) != COMMAND_OK)
		{
			PutByte(0x56);
			break;
		}
		if (Poll_InBusy() != COMMAND_OK)
		{
			PutByte(0x57);
			break;
		}

		if (C2_WriteDR(0xAD) != COMMAND_OK)
		{
			PutByte(0x58);
			break;
		}
		if (Poll_InBusy() != COMMAND_OK)
		{
			PutByte(0x59);
			break;
		}

		if (C2_WriteDR(0xA5) != COMMAND_OK)
		{
			PutByte(0x5A);
			break;
		}
		if (Poll_InBusy() != COMMAND_OK)
		{
			PutByte(0x5B);
			break;
		}

		if (Poll_OutReady() != COMMAND_OK)
		{
			PutByte(0x5C);
			break;
		}

		data = C2_ReadDR();
		if (C2_RESPONSE != COMMAND_OK)
		{
			PutByte(0x5D);
			break;
		}
		if (data != COMMAND_OK)
		{
			PutByte(0x5E);
			PutByte(data);
			break;
		}

		break;
	}
}

/*******************************************************
 * 
 * Erase Entire Flash (command 04)
 * Return:
 *	 0x0D
 * 
 *******************************************************/
void C2_Erase_Flash_04()
{
	C2_RESPONSE = COMMAND_NO_CONNECT;
	byte data;
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

/*******************************************************
 * 
 * Get Firmware Version
 * Return:
 *	version number
 * 
 *******************************************************/
void Get_Firmware_Version()
{
	PutByte(0x44);
	PutByte(0x06);
	C2_RESPONSE = COMMAND_OK;
}

/*******************************************************
 * 
 * Set FPDAT register address
 * 
 *******************************************************/
void Set_FPDAT_Address()
{
	C2ADD_FPDAT = GetNextByte();
	if (C2_RESPONSE == COMMAND_BAD_DATA)
		return;
	C2_RESPONSE = COMMAND_OK;
}

/*******************************************************
 * 
 * Get FPDAT register address
 * 
 *******************************************************/
void Get_FPDAT_Address()
{
	PutByte(C2ADD_FPDAT);
	C2_RESPONSE = COMMAND_OK;
}

/*******************************************************
 * 
 * Read Memory
 *	06, read flash
 *	09, read SFR
 *	0B, read RAM
 *	0E, read XRAM
 * Return:
 *	0xD
 * 
 *******************************************************/
void C2_Read_Memory(byte memType)
{
	byte address16bit = (memType == C2_FP_READ_XRAM || memType == C2_FP_READ_FLASH ? 1 : 0);
	byte lowAddress = GetNextByte();
	byte highAddress = 0;
	if (address16bit)
		highAddress = GetNextByte();
	byte byteCount = GetNextByte();
	byte data;

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

/*******************************************************
 * 
 * Write Memory
 *	07, write to flash
 *	0A, write to SFR
 *	0C, write to RAM
 *	0F, write to XRAM
 * Return:
 *	0xD
 * 
 *******************************************************/
void C2_Write_Memory(byte memType)
{
	byte address16bit = (memType == C2_FP_WRITE_XRAM || memType == C2_FP_WRITE_FLASH ? 1 : 0);
	byte lowAddress = GetNextByte();
	byte highAddress = 0;
	if (address16bit)
		highAddress = GetNextByte();
	byte byteCount = GetNextByte();

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

/*******************************************************
 * 
 * Erase Flash Sector
 * Return:
 *	0xD
 * 
 *******************************************************/
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

/*******************************************************
 * 
 * C2 protocol helpers
 * 
 *******************************************************/

//
// Make RESET
//
byte C2_Reset(void)
{
	cli();
	C2CK_DriverOn();
	C2CK_PORT &= ~C2CK_BIT;
	delayMicroseconds(20);
	C2CK_PORT |= C2CK_BIT;
	delayMicroseconds(2);
	sei();
	C2_RESPONSE = COMMAND_OK;
}

//
// Make pulse on C2CLK line
//
void Pulse_C2CLK(void)
{
	C2CK_PORT &= ~C2CK_BIT;
	asm volatile("nop\n\t");
	asm volatile("nop\n\t");
	C2CK_PORT |= C2CK_BIT;
}

//
// Drive On/Off C2D line
//
void C2D_DriverOn()
{
	C2D_DDR |= C2D_BIT;
}

void C2D_DriverOff()
{
	C2D_PORT &= ~C2D_BIT;
	C2D_DDR  &= ~C2D_BIT;
}

//
// Drive On/Off C2CLK line
//
void C2CK_DriverOn()
{
	C2CK_PORT |= C2CK_BIT;
	C2CK_DDR  |= C2CK_BIT;
}

void C2CK_DriverOff()
{
	C2CK_PORT |=  C2CK_BIT;
	C2CK_DDR  &= ~C2CK_BIT;
}

//
// Write to FPDAT register
//
byte C2_Write_FPDAT_Read(byte data)
{
	if (C2_Write_FPDAT(data) == COMMAND_OK)
		return C2_Read_FPDAT();
	return 0;
}

//
// Wait for set OutReady
//
byte Poll_InBusy()
{
	C2_RESPONSE = COMMAND_OK;
	unsigned int timeout = 50000;
	byte h_timeout = 0;
	while ((C2_ReadAR() & C2ADD_INBUSY))
	{
		if (!h_timeout)
		{
			h_timeout = 50;
			if (--timeout == 0)
			{
				C2_RESPONSE = COMMAND_TIMEOUT;
				break;
			}
		}
		--h_timeout;
		delayMicroseconds(1);
	}
	return C2_RESPONSE;
}

//
// Wait for set OutReady
//
byte Poll_OutReady()
{
	C2_RESPONSE = COMMAND_OK;
	unsigned int timeout = 50000;
	byte h_timeout = 0;
	while (!(C2_ReadAR() & C2ADD_OUTREADY))
	{
		if (!h_timeout)
		{
			h_timeout = 50;
			if (--timeout == 0)
			{
				C2_RESPONSE = COMMAND_TIMEOUT;
				break;
			}
		}
		--h_timeout;
		delayMicroseconds(1);
	}
	return C2_RESPONSE;
}

//
// Read from FPDAT
//
byte C2_Read_FPDAT()
{
	if (Poll_OutReady() == COMMAND_OK)
	{
		C2_WriteAR(C2ADD_FPDAT);
		return C2_ReadDR();
	}
	return 0;
}

//
// Write to FPDAT with wait InBusy clear
//
byte C2_Write_FPDAT(byte data)
{
	C2_WriteAR(C2ADD_FPDAT);

	if (C2_WriteDR(data) == COMMAND_OK)
	{
		unsigned int timeout = 50000;
		byte h_timeout = 0;
		while (C2_ReadAR() & C2ADD_INBUSY)
		{
			if (!h_timeout)
			{
				h_timeout = 50;
				if (--timeout == 0)
				{
					C2_RESPONSE = COMMAND_TIMEOUT;
					break;
				}
			}
			--h_timeout;
			delayMicroseconds(1);
		}
	}
	return C2_RESPONSE;
}

//-----------------------------------------------------------------------------------
// C2_ReadAR()
//-----------------------------------------------------------------------------------
// - Performs a C2 Address register read
// - Returns the 8-bit register content
//
byte C2_ReadAR()
{
	cli();
	// START field
	Pulse_C2CLK();

	// INS field (10b, LSB first)
	C2D_PORT &= ~C2D_BIT;
	C2D_DriverOn();
	Pulse_C2CLK();
	C2D_PORT |= C2D_BIT;
	Pulse_C2CLK();
	C2D_DriverOff();

	// ADDRESS field
	byte data = 0;
	for (byte i = 0; i < 8; i++)
	{
		Pulse_C2CLK();
		data = data >> 1;
		data &= 0x7F;
		if (C2D_PIN & C2D_BIT)
			data |= 0x80;
	}

	// STOP field
	Pulse_C2CLK();
	sei();

	C2_RESPONSE = COMMAND_OK;
	return data;
}

//-----------------------------------------------------------------------------------
// C2_WriteAR()
//-----------------------------------------------------------------------------------
// - Performs a C2 Address register write (writes the <addr> input 
//	 to Address register)
//
void C2_WriteAR(byte addr)
{
	cli();
	// START field
	Pulse_C2CLK();

	// INS field (11b, LSB first)
	C2D_PORT |= C2D_BIT;
	C2D_DriverOn();
	Pulse_C2CLK();
	Pulse_C2CLK();

	// ADDRESS field
	for (byte i = 0; i < 8; i++)
	{
		if (addr & 0x01)
			C2D_PORT |= C2D_BIT;
		else
			C2D_PORT &= ~C2D_BIT;
		addr = addr >> 1;
		Pulse_C2CLK();
	}

	// STOP field
	C2D_DriverOff();
	Pulse_C2CLK();
	sei();

	C2_RESPONSE = COMMAND_OK;
	return;
}

//-----------------------------------------------------------------------------------
// C2_ReadDR()
//-----------------------------------------------------------------------------------
// - Performs a C2 Data register read
// - Returns the 8-bit register content
//
byte C2_ReadDR()
{
	cli();
	// START field
	Pulse_C2CLK();

	C2D_PORT &= ~C2D_BIT;
	C2D_DriverOn();

	Pulse_C2CLK();		// INS field (00b, LSB first)
	Pulse_C2CLK();

	Pulse_C2CLK();		// LENGTH field (00b -> 1 byte)
	Pulse_C2CLK();

	// WAIT field
	C2D_DriverOff();	// Disable C2D driver for input
	byte retry = 0;
	byte data = 0;
	do
		Pulse_C2CLK();
	while (--retry && !(C2D_PIN & C2D_BIT));

	if (retry)
	{
		// DATA field
		for (byte i = 0; i < 8; i++)
		{
			Pulse_C2CLK();
			data = data >> 1;
			if (C2D_PIN & C2D_BIT)
				data |= 0x80;
			else
				data &= 0x7F;
		}

		// STOP field
		Pulse_C2CLK();
	}

	sei();

	C2_RESPONSE = (retry ? COMMAND_OK : COMMAND_TIMEOUT);
	return data;
}

//-----------------------------------------------------------------------------------
// C2_WriteDR()
//-----------------------------------------------------------------------------------
// - Performs a C2 Data register write (writes <data> input to data register)
//
byte C2_WriteDR(byte data)
{
	cli();
	// START field
	Pulse_C2CLK();

	// INS field (01b, LSB first)
	C2D_PORT |= C2D_BIT;
	C2D_DriverOn();
	Pulse_C2CLK();
	C2D_PORT &= ~C2D_BIT;
	Pulse_C2CLK();

	// LENGTH field (00b -> 1 byte)
	Pulse_C2CLK();
	Pulse_C2CLK();

	// DATA field
	for (byte i = 0; i < 8; i++)
	{
		if (data & 0x01)
			C2D_PORT |= C2D_BIT;
		else
			C2D_PORT &= ~C2D_BIT;
		data = data >> 1;
		Pulse_C2CLK();
	}

	C2D_DriverOff();
	byte retry = 200;
	do
		Pulse_C2CLK();
	while (--retry && !(C2D_PIN & C2D_BIT));

	// STOP field
	Pulse_C2CLK();

	sei();

	C2_RESPONSE = (retry ? COMMAND_OK : COMMAND_TIMEOUT);
	return C2_RESPONSE;
}

//
// Blink LED
//
void BlinkLED(byte flashes)
{
	delay(100);
	while (flashes-- > 0)
	{
		LED_ON();
		delay(100);
		LED_OFF();
		delay(250);
	}
}

char hex2char(byte data)
{
	if (data >= 0x0A)
		Serial.write(data + ('A' - 0x0A));
	else
		Serial.write(data + '0');
}

void PutByte(byte data)
{
	hex2char((data >> 4) & 0x0F);
	hex2char(data & 0x0F);
}

