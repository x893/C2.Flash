#include "Platform.h"
#include "Timing.h"
#include "Errors.h"
#include "system_stm32f10x.h"

uint16_t TicksPerUS;
/**************************************************************************//**
 *
 * @brief	Initialize board
 *
 *****************************************************************************/
void BoardInit(void)
{
	GPIO_InitTypeDef GPIO_InitStructure;
	USART_InitTypeDef USART_InitStructure;

	Pin_Init();
	
	LED_CLK();
	BSP_LedSet(0);
	GPIO_InitStructure.GPIO_Pin = LED_PIN;
	GPIO_InitStructure.GPIO_Speed = GPIO_Speed_50MHz;
	GPIO_InitStructure.GPIO_Mode = GPIO_Mode_Out_PP;
	GPIO_Init(LED_PORT, &GPIO_InitStructure);

	SystemCoreClockUpdate();
	TimingInit();

	PC_GPIO_CLK();
	GPIO_InitStructure.GPIO_Pin = PC_PIN_RX;
	GPIO_InitStructure.GPIO_Mode = GPIO_Mode_IPU;
	GPIO_Init(PC_PIN_PORT, &GPIO_InitStructure);

	GPIO_InitStructure.GPIO_Pin = PC_PIN_TX;
	GPIO_InitStructure.GPIO_Speed = GPIO_Speed_50MHz;
	GPIO_InitStructure.GPIO_Mode = GPIO_Mode_AF_PP;
	GPIO_Init(PC_PIN_PORT, &GPIO_InitStructure);

	PC_UART_CLK();
	USART_InitStructure.USART_BaudRate = 115200;
	USART_InitStructure.USART_WordLength = USART_WordLength_8b;
	USART_InitStructure.USART_StopBits = USART_StopBits_1;
	USART_InitStructure.USART_Parity = USART_Parity_No;
	USART_InitStructure.USART_HardwareFlowControl = USART_HardwareFlowControl_None;
	USART_InitStructure.USART_Mode = USART_Mode_Rx | USART_Mode_Tx;
	USART_Init(PC_UART, &USART_InitStructure);
	USART_Cmd(PC_UART, ENABLE);
}

void PC_Send(uint8_t ch)
{
	if (ch == '\n')
		PC_Send('\r');
	USART_SendData(PC_UART, ch);
    while (USART_GetFlagStatus(PC_UART, USART_FLAG_TXE) == RESET)
    { }
}

uint8_t PC_Receive(void)
{
    if (USART_GetFlagStatus(PC_UART, USART_FLAG_RXNE) == RESET)
		return 0;
    return (USART_ReceiveData(PC_UART));
}

void BSP_LedSet(uint8_t led)
{
	if (led == 0)
	{
		GPIO_SetBits(LED_PORT, LED_PIN);
	}
}

void BSP_LedClear(uint8_t led)
{
	if (led == 0)
	{
		GPIO_ResetBits(LED_PORT, LED_PIN);
	}
}

bool Stopwatch_active;			// '1' if Stopwatch_ms is counting
uint32_t Stopwatch_ms;
uint32_t Stopwatch_us;

volatile uint32_t msTicks = 0;	// counts 1ms timeTicks
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

void SetTimeout_ms (uint16_t timeout_ms)
{
	msDelay = timeout_ms;
}

bool IsDoneTimeout_ms(void)
{
	return (msDelay == 0 ? true : false);
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
	Stopwatch_us = DWT->CYCCNT / TicksPerUS;
	return NO_ERROR;
}

void TimingInit(void)
{
	TicksPerUS = SystemCoreClock / 1000000UL;
	/* Enable DWT */
	CoreDebug->DEMCR |= CoreDebug_DEMCR_TRCENA_Msk;
	/* Make sure CYCCNT is running */
	DWT->CTRL |= DWT_CTRL_CYCCNTENA_Msk;

	if (SysTick_Config(SystemCoreClock / 1000))
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
void Wait_us (uint16_t us)
{
	uint32_t time = TicksPerUS * us;
	DWT->CYCCNT = 0;
	while (DWT->CYCCNT < time)	// repeat until <us> have elapsed
	{ }
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
void Wait_ms (uint16_t ms)
{
	while (ms-- != 0)
		Wait_us(1000);
}

void SetTimeout_us (uint16_t us)
{
	usDelay = TicksPerUS * us;
	DWT->CYCCNT = 0;
}

bool IsDoneTimeout_us(void)
{
	return (usDelay > DWT->CYCCNT ? false : true);
}

void delay_nops(uint16_t nops)
{
	while (nops-- != 0)
		__NOP();
}

void STROBE_C2CK(void)
{
	delay_nops(2);
	C2CK = 0;
	delay_nops(4);
	C2CK = 1;
	delay_nops(4);
}

