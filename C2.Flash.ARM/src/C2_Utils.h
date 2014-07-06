#ifndef __C2_UTILS_H__
#define __C2_UTILS_H__

#include "Devices.h"

uint8_t C2_Reset(void);
uint8_t C2_WriteAR(uint8_t addr);
uint8_t C2_ReadAR(void);
uint8_t C2_WriteDR(uint8_t dat, uint16_t timeout_us);
uint8_t C2_ReadDR(uint16_t timeout_us);

uint8_t C2_Poll_InBusy(uint16_t timeout_ms);
uint8_t C2_Poll_OutReady(uint16_t timeout_ms);
uint8_t C2_Poll_OTPBusy(uint16_t timeout_ms);

uint8_t C2_Halt(void);
uint8_t C2_GetDevID(uint8_t *devid);
uint8_t C2_GetRevID(uint8_t *revid);
uint8_t C2_ReadSFR(uint8_t sfraddress, uint8_t *sfrdata);
uint8_t C2_WriteSFR(uint8_t sfraddress, uint8_t sfrdata);

uint8_t C2_WriteCommand(uint8_t command, uint16_t C2_poll_inbusy_timeout_ms);
uint8_t C2_ReadResponse(uint16_t C2_poll_outready_timeout_ms);
uint8_t C2_ReadData(uint16_t C2_poll_outready_timeout_ms);

uint8_t C2_ReadDirect(uint8_t sfraddress, uint8_t *sfrdata, uint8_t indirect);
uint8_t C2_WriteDirect(uint8_t sfraddress, uint8_t sfrdata, uint8_t indirect);

uint8_t C2_Discover(uint8_t* deviceId, uint8_t* revisionId, uint8_t* derId);

#define C2_AR_OUTREADY			0x01
#define C2_AR_INBUSY			0x02
#define C2_AR_OTPERROR			0x40
#define C2_AR_OTPBUSY			0x80
#define C2_AR_FLBUSY			0x80

#define C2_DEVICEID				0x00
#define C2_REVID				0x01
#define C2_FPCTL				0x02

#define C2_FPCTL_RUNNING		0x00
#define C2_FPCTL_HALT			0x01
#define C2_FPCTL_RESET			0x02
#define C2_FPCTL_CORE_RESET		0x04

//#define C2_FPDAT				0xB4
#define C2_FPDAT_GET_VERSION	0x01
#define C2_FPDAT_GET_DERIVATIVE	0x02
#define C2_FPDAT_DEVICE_ERASE	0x03
#define C2_FPDAT_BLOCK_READ		0x06
#define C2_FPDAT_BLOCK_WRITE	0x07
#define C2_FPDAT_PAGE_ERASE		0x08
#define C2_FPDAT_DIRECT_READ	0x09
#define C2_FPDAT_DIRECT_WRITE	0x0a
#define C2_FPDAT_INDIRECT_READ	0x0b
#define C2_FPDAT_INDIRECT_WRITE	0x0c

#define C2_FPDAT_RETURN_INVALID_COMMAND	0x00
#define C2_FPDAT_RETURN_COMMAND_FAILED	0x02
#define C2_FPDAT_RETURN_COMMAND_OK		0x0D

#define C2_DEVCTL				0x02
#define C2_EPCTL				0xDF
#define C2_EPDAT				0xBF
#define C2_EPADDRH				0xAF
#define C2_EPADDRL				0xAE
#define C2_EPSTAT				0xB7
#define C2_EPSTAT_WRITE_LOCK	0x80
#define C2_EPSTAT_READ_LOCK		0x40
#define C2_EPSTAT_CAL_VALID		0x20
#define C2_EPSTAT_CAL_DONE		0x10
#define C2_EPSTAT_ERROR			0x01

#define C2_EPCTL_READ			0x00
#define C2_EPCTL_WRITE1			0x40
#define C2_EPCTL_WRITE2			0x58
#define C2_EPCTL_FAST_WRITE		0x78

// C2 DR timeouts (us)
#define C2_WRITE_DR_TIMEOUT_US	20000
#define C2_READ_DR_TIMEOUT_US	20000

// C2 Debug timeouts (ms)
#define C2_POLL_INBUSY_TIMEOUT_MS	100
#define C2_POLL_OUTREADY_TIMEOUT_MS	100
#define C2_POLL_OTPBUSY_TIMEOUT_MS	100

enum {C2_DIRECT, C2_INDIRECT};

extern volatile uint8_t C2_AR;
extern volatile uint8_t C2_DR;

#endif // __C2_UTILS_H__
