/***************************************************************************//**
 * @file
 * @brief capsense configuration parameters.
 * @author Energy Micro AS
 * @version 3.20.3
 *******************************************************************************
 * @section License
 * <b>(C) Copyright 2013 Energy Micro AS, http://www.energymicro.com</b>
 *******************************************************************************
 *
 * Permission is granted to anyone to use this software for any purpose,
 * including commercial applications, and to alter it and redistribute it
 * freely, subject to the following restrictions:
 *
 * 1. The origin of this software must not be misrepresented; you must not
 *    claim that you wrote the original software.
 * 2. Altered source versions must be plainly marked as such, and must not be
 *    misrepresented as being the original software.
 * 3. This notice may not be removed or altered from any source distribution.
 * 4. The source and compiled code may only be used on Energy Micro "EFM32"
 *    microcontrollers and "EFR4" radios.
 *
 * DISCLAIMER OF WARRANTY/LIMITATION OF REMEDIES: Energy Micro AS has no
 * obligation to support this Software. Energy Micro AS is providing the
 * Software "AS IS", with no express or implied warranties of any kind,
 * including, but not limited to, any implied warranties of merchantability
 * or fitness for any particular purpose or warranties against infringement
 * of any proprietary rights of a third party.
 *
 * Energy Micro AS will not be liable for any consequential, incidental, or
 * special damages, or any other relief, or for any claim by any third party,
 * arising from your use of this Software.
 *
 *****************************************************************************/
#ifndef __CAPSENSCONFIG_H
#define __CAPSENSCONFIG_H
#ifdef __cplusplus
extern "C" {
#endif

#define ACMP_CAPSENSE                           ACMP0
#define ACMP_CAPSENSE_CLKEN                     CMU_HFPERCLKEN0_ACMP0
#define PRS_CH_CTRL_SOURCESEL_ACMP_CAPSENSE     PRS_CH_CTRL_SOURCESEL_ACMP0
#define PRS_CH_CTRL_SIGSEL_ACMPOUT_CAMPSENSE    PRS_CH_CTRL_SIGSEL_ACMP0OUT

#define ACMP_CHANNELS           8             /**< Number of channels for the Analog Comparator */

#define BUTTON0_CHANNEL         4             /**< Button 0 channel */
#define BUTTON1_CHANNEL         3             /**< Button 1 channel */

#define CAPSENSE_CH_IN_USE  { false, false, false, true, true, false, false, false }

#ifdef __cplusplus
}
#endif
#endif
