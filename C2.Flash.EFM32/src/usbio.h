#ifndef __USBIO_H__
#define __USBIO_H__

#include <stdint.h>

void    USB_printHex(      uint32_t integer   );
int     USB_txByte(        char data          );
uint8_t USB_rxByte(        void               );
void    USB_printString(   const char *string );

#define GETCHAR()	USB_rxByte()
#define PUTCHAR(c)	USB_txByte(c)

#endif	/* __USBIO_H__ */
