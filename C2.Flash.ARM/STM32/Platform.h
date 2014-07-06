#ifndef __PLATFORM_H__
#define __PLATFORM_H__

#include "stm32f10x.h"

#define PERIPH_BITBAND(address, pos)	*(__IO uint32_t *)(PERIPH_BB_BASE | (((uint32_t )address - PERIPH_BASE) << 5) | ((pos) << 2))
#define PIN_MODE(pin, mode)				(((uint32_t)((mode) & 0x0F)) << ((pin & 0x07) << 2))

#define LED_CLK()		RCC_APB2PeriphClockCmd(RCC_APB2Periph_GPIOA, ENABLE)
#define LED_PORT		GPIOA
#define LED_PIN			GPIO_Pin_5

#define PC_GPIO_CLK()	RCC_APB2PeriphClockCmd(RCC_APB2Periph_GPIOA | RCC_APB2Periph_AFIO, ENABLE)
#define PC_PIN_PORT		GPIOA
#define PC_PIN_TX		GPIO_Pin_2
#define PC_PIN_RX		GPIO_Pin_3
#define PC_UART			USART2
#define PC_UART_CLK()	RCC_APB1PeriphClockCmd(RCC_APB1Periph_USART2, ENABLE)

#define C2_PIN_CLK()	RCC_APB2PeriphClockCmd(RCC_APB2Periph_GPIOC, ENABLE);
#define C2_PORT			GPIOC
#define C2_PORT_CR		C2_PORT->CRH

#define C2CK_POS		GPIO_PinSource8
#define C2CK			PERIPH_BITBAND(&(C2_PORT->ODR), C2CK_POS)
#define C2CK_PIN		GPIO_Pin_8
#define C2CK_MODE_MASK	PIN_MODE(C2CK_POS, 0x0F)
#define C2CK_MODE_OUT	PIN_MODE(C2CK_POS, GPIO_Mode_Out_PP | GPIO_Speed_50MHz)
#define C2CK_MODE_IN	PIN_MODE(C2CK_POS, GPIO_Mode_IN_FLOATING)
// GPIO_Mode_IPU)

#define C2D_POS			GPIO_PinSource9
#define C2D				PERIPH_BITBAND(&(C2_PORT->ODR), C2D_POS)
#define C2D_IN			PERIPH_BITBAND(&(C2_PORT->IDR), C2D_POS)
#define C2D_PIN			GPIO_Pin_9
#define C2D_MODE_MASK	PIN_MODE(C2D_POS, 0x0F)
#define C2D_MODE_OUT	PIN_MODE(C2D_POS, GPIO_Mode_Out_PP | GPIO_Speed_50MHz)
#define C2D_MODE_IN		PIN_MODE(C2D_POS, GPIO_Mode_IN_FLOATING)
// GPIO_Mode_IPU)

#define C2CK_DRIVER_ON()	\
	do {															\
		C2CK = 1;													\
		C2_PORT_CR = (C2_PORT_CR & ~C2CK_MODE_MASK) | C2CK_MODE_OUT;\
	} while (0)
#define C2CK_DRIVER_OFF()	\
	do {															\
		C2CK = 1;													\
		C2_PORT_CR = (C2_PORT_CR & ~C2CK_MODE_MASK) | C2CK_MODE_IN;	\
	} while (0)

#define C2D_DRIVER_ON()		\
	do {															\
		C2D = 1;													\
		C2_PORT_CR = (C2_PORT_CR & ~C2D_MODE_MASK) | C2D_MODE_OUT;	\
	} while (0)
#define C2D_DRIVER_OFF()	\
	do {															\
		C2D  = 1;													\
		C2_PORT_CR = (C2_PORT_CR & ~C2D_MODE_MASK) | C2D_MODE_IN;	\
	} while (0)

#define DISABLE_INTERRUPTS()	__disable_irq()
#define ENABLE_INTERRUPTS()		__enable_irq()

void Wait_us(uint16_t us);

void STROBE_C2CK(void);
uint8_t Pin_Init (void);

#define VPP_65_DRIVER_ON()
#define VPP_65_ENABLE()
#define VPP_65_DISABLE()
#define VPP_65_DRIVER_OFF()

void	PC_Send(uint8_t ch);
uint8_t	PC_Receive(void);

#define GETCHAR()	PC_Receive()
#define PUTCHAR(ch)	PC_Send(ch)

void	BSP_LedSet(uint8_t led);
void	BSP_LedClear(uint8_t led);

#endif
