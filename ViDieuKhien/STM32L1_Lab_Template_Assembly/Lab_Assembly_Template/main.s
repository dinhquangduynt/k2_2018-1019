;******************** (C) Yifeng ZHU ********************
; @file    main.s
; @author  Yifeng Zhu
; @version V1.0.0
; @date    May-5-2012
; @note    
; @brief   Assembly code for STM32L1xx Discovery Kit
; @note
;          This code is for the book "Embedded Systems with ARM Cortex-M3 
;          Microcontrollers in Assembly Language and C, Yifeng Zhu, 
;          ISBN-10: 0982692625.
; @attension
;          This code is provided for education purpose. The author shall not be 
;          held liable for any direct, indirect or consequential damages, for any 
;          reason whatever. More information can be found from book website: 
;          http://www.eece.maine.edu/~zhu/book
;********************************************************

				
; STM32L1xx Discovery Kit:
;    - USER Pushbutton: connected to PA0 (GPIO Port A, PIN 0), CLK RCC_AHBENR_GPIOAEN
;    - RESET Pushbutton: connected RESET
;    - GREEN LED: connected to PB7 (GPIO Port B, PIN 7), CLK RCC_AHBENR_GPIOBEN 
;    - BLUE LED: connected to PB6 (GPIO Port B, PIN 6), CLK RCC_AHBENR_GPIOBEN
;    - Linear touch sensor/touchkeys: PA6, PA7 (group 2),  PC4, PC5 (group 9),  PB0, PB1 (group 3)

				INCLUDE stm32l1xx_constants.s		; Load Constant Definitions
				INCLUDE stm32l1xx_tim_constants.s   ; TIM Constants

				AREA    main, CODE, READONLY
				EXPORT	__main						; make __main visible to linker
				ENTRY
				
__main			PROC

				LDR  	R0, =array ;R0=men addr cua array
				LDR  	R1, =num1 ;R1=men addr cua array
				LDR  	R2, =num2 ;R2=men addr cua array
				LDR  	R3, =num4 ;R3=men addr cua array
				LDR  	R4, =string ;R4=men addr cua array
				LDR     R5, =0x1111
				ORR     R0, R5 ;set bit 0,4,8,12
				LDR     R5, =0xFFFFFFF
				BIC 	R1,R5; clear bit 0...27 cua R1
				LDR 	R5, =0xC0000000
				BIC 	R2,R5 ; do bit 31 30 cua R2
				
					
stop 			B 		stop     					; dead loop & program hangs here

				ENDP
				ALIGN			

				AREA    myData, DATA, READWRITE
				ALIGN
array			DCD   1, 2, 3, 4 ;cap nhat 4 byte
num1			DCB   5          ;cap nhat 1 byte
num2 			DCW	  6, 7, 8, 8 ;cap nhat 2 byte
num4			DCD	  9, 10		 ;cap nhat 4 byte
string 			DCB   "hello",0  ;cap nhat cac byte
				END
