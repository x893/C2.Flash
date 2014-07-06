#ifndef __C2_FLASH_H__
#define __C2_FLASH_H__

#include <stdint.h>

uint8_t C2_FLASH_Read (			uint8_t *dest, uint32_t addr, uint16_t length);
uint8_t C2_OTP_Read (			uint8_t *dest, uint32_t addr, uint16_t length);
uint8_t C2_FLASH_Write (		uint32_t addr, uint8_t *src, uint16_t length);
uint8_t C2_OTP_Write (			uint32_t addr, uint8_t *src, uint16_t length);
uint8_t C2_FLASH_PageErase (	uint32_t addr);
uint8_t C2_FLASH_DeviceErase (	void);
uint8_t C2_FLASH_BlankCheck (	uint32_t addr, uint32_t length);
uint8_t C2_OTP_BlankCheck (		uint32_t addr, uint32_t length);
uint8_t C2_Get_LockByte (		void);

#endif // __C2_FLASH_H__
