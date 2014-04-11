#ifndef __TIMING_H__
#define __TIMING_H__

#include <stdint.h>
#include <stdbool.h>

void TimingInit(void);

uint8_t Wait_us (uint16_t us);
uint8_t Wait_ms (uint16_t ms);

uint8_t Start_Stopwatch(void);
uint8_t Stop_Stopwatch(void);

void Set_Timeout_ms_1(uint16_t timeout_ms);
void Set_Timeout_us_1(uint16_t timeout_us);

void SetLedPeriod(uint16_t time_off, uint16_t time_on);

bool Timeout_us_1(void);
bool Timeout_ms_1(void);

extern uint32_t Stopwatch_ms;
extern uint32_t Stopwatch_us;

#endif	/* __TIMING_H__ */
