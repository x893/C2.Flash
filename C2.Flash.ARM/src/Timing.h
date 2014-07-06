#ifndef __TIMING_H__
#define __TIMING_H__

#include <stdint.h>
#include <stdbool.h>

void TimingInit(void);

void Wait_us(uint16_t us);
void Wait_ms(uint16_t ms);

uint8_t Start_Stopwatch(void);
uint8_t Stop_Stopwatch(void);
void SetLedPeriod(uint16_t time_off, uint16_t time_on);

void SetTimeout_ms(uint16_t timeout_ms);
void SetTimeout_us(uint16_t timeout_us);

bool IsDoneTimeout_ms(void);
bool IsDoneTimeout_us(void);

extern uint32_t Stopwatch_ms;
extern uint32_t Stopwatch_us;

#endif	/* __TIMING_H__ */
