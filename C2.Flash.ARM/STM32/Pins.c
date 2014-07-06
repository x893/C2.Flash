#include "Platform.h"
#include "Timing.h"
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
	C2_PIN_CLK();
	C2CK_DRIVER_OFF();
	C2D_DRIVER_OFF();
	return NO_ERROR;
}
