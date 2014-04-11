#include <stdint.h>

#include "em_cmu.h"
#include "em_emu.h"

#include "bsp.h"

#include "Timing.h"
#include "Errors.h"

#define DWT_CYCCNT  *(volatile uint32_t *)0xE0001004
#define DWT_CTRL    *(volatile uint32_t *)0xE0001000

bool Stopwatch_active;	// '1' if Stopwatch_ms is counting
uint32_t Stopwatch_ms;
uint32_t Stopwatch_us;

volatile uint32_t msTicks = 0;	/* counts 1ms timeTicks */
volatile uint32_t msDelay = 0;
volatile uint32_t usDelay = 0;
uint16_t msLedOn, msLedRunOn;
uint16_t msLedOff, msLedRunOff;

void SysTick_Handler(void)
{
	msTicks++;
	if (msDelay != 0)
		msDelay--;

	if (Stopwatch_active)
		Stopwatch_ms++;

	if (msLedRunOff != 0)
	{
		if (--msLedRunOff == 0)
		{
			BSP_LedSet(0);
			msLedRunOn = msLedOn;
		}
	}
	if (msLedRunOn != 0)
	{
		if (--msLedRunOn == 0)
		{
			BSP_LedClear(0);
			msLedRunOff = msLedOff;
		}
	}
}

void SetLedPeriod(uint16_t time_off, uint16_t time_on)
{
	__disable_irq();
	msLedRunOff = 0;
	msLedRunOn  = 0;
	__enable_irq();

	BSP_LedClear(0);
	msLedOff = time_off;
	msLedOn  = time_on;
	msLedRunOff = time_off;
}

void TimingInit(void)
{
	/* Enable DWT */
	CoreDebug->DEMCR |= CoreDebug_DEMCR_TRCENA_Msk;
	/* Make sure CYCCNT is running */
	DWT_CTRL |= 1;

	if (SysTick_Config(CMU_ClockFreqGet(cmuClock_CORE) / 1000))
		while (1) ;
}

//-----------------------------------------------------------------------------
// Wait_us
//-----------------------------------------------------------------------------
//
// Return Value : error code
// Parameters   : number of us to wait
//
// This value waits for TFus to go from 0 to 1, at least <us> times.
//
//-----------------------------------------------------------------------------
uint8_t Wait_us (uint16_t us)
{
	uint32_t time = CMU_ClockFreqGet(cmuClock_CORE) / 1000000L * us;
	DWT_CYCCNT = 0;
	while (DWT_CYCCNT < time)	// repeat until <us> have elapsed
	{
		__NOP();
	}
	return NO_ERROR;
}

void Set_Timeout_us_1 (uint16_t timeout_us)
{
	usDelay = timeout_us;
	DWT_CYCCNT = 0;
}

bool Timeout_us_1(void)
{
	return (usDelay <= DWT_CYCCNT ? false : true);
}

void Set_Timeout_ms_1 (uint16_t timeout_ms)
{
	msDelay = timeout_ms;
}

bool Timeout_ms_1(void)
{
	return (msDelay != 0 ? false : true);
}

//-----------------------------------------------------------------------------
// Wait_ms
//-----------------------------------------------------------------------------
//
// Return Value : error code
// Parameters   : number of ms to wait
//
// This value waits for TFms to go from 0 to 1, at least <ms> times.
//
//-----------------------------------------------------------------------------
uint8_t Wait_ms (uint16_t ms)
{
	msDelay = ms;
	while (msDelay != 0)	// repeat until <ms> have elapsed
	{
		EMU_EnterEM1();
	}
	return NO_ERROR;
}

//-----------------------------------------------------------------------------
// Start_Stopwatch
//-----------------------------------------------------------------------------
//
// Return Value : error code
// Parameters   : None
//
// This function starts the Stopwatch function.
//
//-----------------------------------------------------------------------------
uint8_t Start_Stopwatch (void)
{
	Stopwatch_active = 0;
	Stopwatch_ms = 0;
	Stopwatch_us = 0;
	Stopwatch_active = 1;
	return NO_ERROR;
}

//-----------------------------------------------------------------------------
// Stop_Stopwatch
//-----------------------------------------------------------------------------
//
// Return Value : error code
// Parameters   : None
//
// This function stops the Stopwatch function.
//
//-----------------------------------------------------------------------------
uint8_t Stop_Stopwatch (void)
{
	Stopwatch_active = 0;
	Stopwatch_us = DWT_CYCCNT;
	return NO_ERROR;
}
