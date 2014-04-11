#include <stdio.h>
#include "em_device.h"
#include "em_cmu.h"
#include "em_emu.h"
#include "em_usb.h"
#include "cdc.h"
#include "usbio.h"

#include "bsp.h"

/** Version string, used when the user connects */
#define USBCDC_VERSION_STRING "USBCDC 1.01"

/*** Function prototypes. ***/
void c2_main(  void );
void commandlineLoop(  void );
void Disconnect(int predelay, int postdelay);
void TimingInit(void);

/*** The descriptors for a USB CDC device. ***/
#include "descriptors.h"

/**************************************************************************//**
 * The main entry point.
 *****************************************************************************/
int main(void)
{
	/* Enable peripheral clocks. */
	CMU->HFPERCLKDIV = CMU_HFPERCLKDIV_HFPERCLKEN;
	CMU->HFPERCLKEN0 = CMU_HFPERCLKEN0_GPIO;

	/* Enable DMA interface */
	CMU->HFCORECLKEN0 = CMU_HFCORECLKEN0_DMA;

	/* Try to start HFXO. */
	CMU_OscillatorEnable( cmuOsc_HFXO, true, true );

	BSP_LedsInit();
	BSP_LedSet(0);
	BSP_LedSet(1);

	USBTIMER_Init();
	CMU_ClockSelectSet( cmuClock_HF, cmuSelect_HFXO );
	TimingInit();
	USBD_Init( &initstruct );       /* Start USB CDC functionality  */

	/* Wait for USB connection */
	while (!CDC_Configured)
	{
		USBTIMER_DelayMs( 100 );
	}
	BSP_LedClear(0);

	// commandlineLoop();
	c2_main();
}

/**************************************************************************//**
 * @brief
 *   The main command line loop. Placed in Ram so that it can still run after
 *   a destructive write operation.
 *   NOTE: __ramfunc is a IAR specific instruction to put code into RAM.
 *   This allows the bootloader to survive a destructive upload.
 *****************************************************************************/
void commandlineLoop( void )
{
	uint8_t  c;

	/* The main command loop */
	while (1)
	{
		/* Retrieve new character */
		c = USB_rxByte();
		/* Echo */
		if (c != 0)
		{
			USB_txByte( c );
		}

		switch (c)
		{
			/* Bootloader version command */
			case 'i':
				/* Print version */
				USB_PUTS("\r\n" USBCDC_VERSION_STRING "\r\n");
				break;

			/* Reset command */
			case 'r':
				Disconnect( 5000, 2000 );

				/* Write to the Application Interrupt/Reset Command Register to reset
				 * the EFM32. See section 9.3.7 in the reference manual. */
				SCB->AIRCR = 0x05FA0004;
				break;

			/* Unknown command */
			case 0:
				/* Timeout waiting for RX - avoid printing the unknown string. */
				break;

			default:
				USB_PUTS( "\r\n?\r\n" );
		}
	}
}

/**************************************************************************//**
 * Disconnect USB link with optional delays.
 *****************************************************************************/
void Disconnect( int predelay, int postdelay )
{
	if ( predelay )
	{
		/* Allow time to do a disconnect in a terminal program. */
		USBTIMER_DelayMs( predelay );
	}

	USBD_Disconnect();

	if ( postdelay )
	{
		/*
		 * Stay disconnected long enough to let host OS tear down the
		 * USB CDC driver.
		 */
		USBTIMER_DelayMs( postdelay );
	}
}
