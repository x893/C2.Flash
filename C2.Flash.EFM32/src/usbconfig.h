#ifndef __USBCONFIG_H__
#define __USBCONFIG_H__

#include "config.h"

#ifdef __cplusplus
extern "C" {
#endif

#define USB_DEVICE

/****************************************************************************
**                                                                         **
** Specify number of endpoints used (in addition to EP0).                  **
**                                                                         **
*****************************************************************************/
#define NUM_EP_USED 3

/****************************************************************************
**                                                                         **
** Specify number of application timers you need.                          **
**                                                                         **
*****************************************************************************/
#define NUM_APP_TIMERS 0

/****************************************************************************
**                                                                         **
** Configure serial port debug output.                                     **
**                                                                         **
*****************************************************************************/

extern int USB_txByte(char c);
#define USER_PUTCHAR  USB_txByte
#define USB_USE_PRINTF

#ifdef __cplusplus
}
#endif

#endif /* __USBCONFIG_H__ */
