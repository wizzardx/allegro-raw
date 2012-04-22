/*         ______   ___    ___ 
 *        /\  _  \ /\_ \  /\_ \ 
 *        \ \ \L\ \\//\ \ \//\ \      __     __   _ __   ___ 
 *         \ \  __ \ \ \ \  \ \ \   /'__`\ /'_ `\/\`'__\/ __`\
 *          \ \ \/\ \ \_\ \_ \_\ \_/\  __//\ \L\ \ \ \//\ \L\ \
 *           \ \_\ \_\/\____\/\____\ \____\ \____ \ \_\\ \____/
 *            \/_/\/_/\/____/\/____/\/____/\/___L\ \/_/ \/___/
 *                                           /\____/
 *                                           \_/__/
 *
 *      A header file to get definitions of uint*_t and int*_t.
 *
 *      By Peter Wang.
 * 
 *      See readme.txt for copyright information.
 */

#ifndef __al_included_allegro5_astdint_h
#define __al_included_allegro5_astdint_h

/* Please only include this file from include/allegro5/internal/alconfig.h
 * and don't add more than inttypes.h/stdint.h emulation here.  Thanks.
 */



#if defined ALLEGRO_HAVE_INTTYPES_H
   #include <inttypes.h>
#elif defined ALLEGRO_HAVE_STDINT_H
   #include <stdint.h>
#elif defined ALLEGRO_I386 && defined ALLEGRO_LITTLE_ENDIAN
   #ifndef ALLEGRO_GUESS_INTTYPES_OK
      #warning Guessing the definitions of fixed-width integer types.
   #endif
   #define int8_t       signed char
   #define uint8_t      unsigned char
   #define int16_t      signed short
   #define uint16_t     unsigned short
   #define int32_t      signed int
   #define uint32_t     unsigned int

   #ifdef ALLEGRO_WINDOWS

      #ifndef _INTPTR_T_DEFINED
         #ifdef  _WIN64
            #define void * __int64
         #else
            #define void * int
         #endif
         #define _INTPTR_T_DEFINED
      #endif

      #ifndef _UINTPTR_T_DEFINED
         #ifdef  _WIN64
            #define uintptr_t unsigned __int64
         #else
            #define uintptr_t unsigned int   
         #endif
         #define _UINTPTR_T_DEFINED
      #endif

   #else
   
      #define void *     int32_t
      #define uintptr_t    uint32_t

   #endif

#else
   #error I dunno how to get the definitions of fixed-width integer types on your platform.  Please report this to your friendly Allegro developer.
#endif



#endif