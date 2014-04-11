#include <stdio.h>
#include <stdbool.h>
#include "em_device.h"
#include "em_usb.h"
#include "usbio.h"
#include "config.h"

#define USB_BUF_SIZ 256

STATIC_UBUF( usbBuffer, USB_BUF_SIZ );

volatile bool      usbXferDone;
USB_Status_TypeDef usbXferStatus;

/**************************************************************************//**
 * @brief
 *    Callback function called whenever a packet with data has been
 *    transferred on USB.
 *****************************************************************************/
static int UsbDataXferred(	USB_Status_TypeDef status,
							uint32_t xferred,
							uint32_t remaining
							)
{
	(void)remaining;            /* Unused parameter */

	usbXferStatus = status;
	usbXferDone   = true;

	return USB_STATUS_OK;
}

/***************************************************************************//**
 * @brief
 *   Prints an int in hex.
 *
 * @param integer
 *   The integer to be printed.
 ******************************************************************************/
void USB_printHex( uint32_t integer )
{
	char c;
	int     i, j, digit;

	for ( i = 28, j = 0; i >= 0; i -= 4, j++ )
	{
		digit = (integer >> i) & 0xF;
		if (digit < 10)
			c = digit + '0';
		else
			c = digit + 'A' - 10;
		usbBuffer[ j ] = c;
	}

    usbBuffer[ j ] = '\0';
    USB_PUTS((char *)usbBuffer);
}

/**************************************************************************//**
 * @brief Get single byte from USART or USB
 *****************************************************************************/
uint8_t USB_rxByte( void )
{
	usbXferDone = false;
	USBD_Read( EP_DATA_OUT, usbBuffer, USB_BUF_SIZ, UsbDataXferred );
	while ( !usbXferDone ) { }
	return (usbXferStatus == USB_STATUS_OK ? usbBuffer[0] : 0);
}

/**************************************************************************//**
 * @brief Transmit single byte to USART or USB
 *****************************************************************************/
int USB_txByte( char data )
{
	if (data == '\n')
		USB_txByte('\r');
	usbBuffer[ 0 ] = data;
	usbXferDone = false;
	USBD_Write( EP_DATA_IN, usbBuffer, 1, UsbDataXferred );
	while ( !usbXferDone ) { }
	return (usbXferStatus == USB_STATUS_OK ? (int)data : 0);
}

#if defined(__CC_ARM)
int fputc(int ch, FILE *f)
{
	return USB_txByte(ch);
}
#else
	#error Unknown compiler
#endif

/**************************************************************************//**
 * @brief Transmit null-terminated string to USART or USB
 *****************************************************************************/
void USB_printString( const char *string )
{
	int len = strlen( (char*)string );
	memcpy( usbBuffer, string, len );
	usbXferDone = false;
	USBD_Write( EP_DATA_IN, usbBuffer, len, UsbDataXferred );
	while ( !usbXferDone ) { }
}
