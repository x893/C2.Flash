#include "em_gpio.h"
#include "Timing.h"
#include "Pins.h"
#include "Errors.h"

//-----------------------------------------------------------------------------
// Pin_Init
//-----------------------------------------------------------------------------
//
// Return Value : None
// Parameters   : None
//
// Configure port pins used for C2 and JTAG interfaces.
//
// The pinout is optimized to map the standard Port I/O header to the
// standard 10-pin debug connector, as follows:
// Pin #   C2 debug   JTAG debug   F340 pin     F340 configuration
// Pin 1   +3V        +3V          P3.0         OD high
// Pin 2   GND        GND          P3.1         PP low -- simulate ground
// Pin 3   GND        GND          P3.2         PP low -- simulate ground
// Pin 4   C2D        TCK          P3.3         OD high
// Pin 5   /RST_share TMS          P3.4         OD high
// Pin 6   C2D_share  TDO          P3.5         OD high
// Pin 7   C2CK       TDI          P3.6         OD high
// Pin 8   VPP_65     VPP_65       P3.7         OD high
// Pin 9   GND        GND          +3.3V        ** MUST CUT stake header! **
// Pin 10  VBUS       NC           GND          no connect
//
//-----------------------------------------------------------------------------

uint8_t Pin_Init (void)
{
	return NO_ERROR;
}

#define C2CK_PORT	gpioPortC
#define C2CK_PIN	0
#define C2D_PORT	gpioPortC
#define C2D_PIN		1

void C2CK_DRIVER_ON(void)
{
	GPIO_PinModeSet(C2CK_PORT, C2CK_PIN, gpioModePushPull, 1);
}

void C2CK_DRIVER_OFF(void)
{
	GPIO_PinModeSet(C2CK_PORT, C2CK_PIN, gpioModeDisabled, 1);
}

void C2D_DRIVER_ON(void)
{
	GPIO_PinModeSet(C2D_PORT, C2D_PIN, gpioModePushPull, GPIO_PinOutGet(C2D_PORT, C2D_PIN));
}
void C2D_DRIVER_OFF(void)
{
	GPIO_PinModeSet(C2D_PORT, C2D_PIN, gpioModeInput, 0);
}

void C2CK_LOW(void)
{
	GPIO_PinOutClear(C2CK_PORT, C2CK_PIN);
}
void C2CK_HIGH(void)
{
	GPIO_PinOutSet(C2CK_PORT, C2CK_PIN);
}

void C2D_LOW(void)
{
	GPIO_PinOutClear(C2D_PORT, C2D_PIN);
}
void C2D_HIGH(void)
{
	GPIO_PinOutSet(C2D_PORT, C2D_PIN);
}
unsigned int C2D_READ(void)
{
	return GPIO_PinInGet(C2D_PORT, C2D_PIN);
}

void STROBE_C2CK(void)
{
	GPIO_PinOutSet(C2CK_PORT, C2CK_PIN);
	GPIO_PinOutClear(C2CK_PORT, C2CK_PIN);
	GPIO_PinOutClear(C2CK_PORT, C2CK_PIN);
	GPIO_PinOutSet(C2CK_PORT, C2CK_PIN);
	GPIO_PinOutSet(C2CK_PORT, C2CK_PIN);
	GPIO_PinOutSet(C2CK_PORT, C2CK_PIN);
}
