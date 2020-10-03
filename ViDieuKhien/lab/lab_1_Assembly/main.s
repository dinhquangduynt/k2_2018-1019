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

				AREA    main, CODE, READONLY
				EXPORT	__main						; make __main visible to linker
				ENTRY

__main			PROC
				; Enable the clock to GPIO Port A & B
				LDR R7, =RCC_BASE;
				LDR R1, [R7, #RCC_AHBENR]		; R1 = RCC->AHBENR
				ORR R1, R1, #RCC_AHBENR_GPIOAEN
				ORR R1, R1, #RCC_AHBENR_GPIOBEN				
				STR R1, [R7, #RCC_AHBENR]
				;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
				; Set pin PB6 as digital output (01)
				LDR R7, =GPIOB_BASE;
				LDR R1, [R7, #GPIO_MODER]		; R1 = GPIOB->MODER
				BIC R1, R1, #(0x03 << 12)
				ORR R1, R1, #(0x01 << 12)
				STR R1, [R7, #GPIO_MODER]
				; Set output type of pin as push-pull (0)
				LDR R1, [R7, #GPIO_OTYPER]		; R1 = GPIOB->OTYPER
				BIC R1, R1, #(1<<6)
				STR R1, [R7, #GPIO_OTYPER]
				; Set output speed of pin (01 = 2MHz, 10 = 10MHz)
				LDR R1, [R7, #GPIO_OSPEEDR]		; R1 = GPIOB->OSPEEDR
				BIC R1, R1, #(0x03 << 12)
				ORR R1, R1, #(0x02 << 12)
				STR R1, [R7, #GPIO_OSPEEDR]
				; Set I/O as no pull-up pull-down (00)
				LDR R1, [R7, #GPIO_PUPDR]		; R1 = GPIOB->PUPDR
				BIC R1, R1, #(0x03 << 12)
				STR R1, [R7, #GPIO_PUPDR]
				;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
				; Set pin PB7 as digital output (01)
				LDR R7, =GPIOB_BASE;
				LDR R1, [R7, #GPIO_MODER]		; R1 = GPIOB->MODER
				BIC R1, R1, #(0x03 << 14)
				ORR R1, R1, #(0x01 << 14)
				STR R1, [R7, #GPIO_MODER]
				; Set output type of pin as push-pull (0)
				LDR R1, [R7, #GPIO_OTYPER]		; R1 = GPIOB->OTYPER
				BIC R1, R1, #(1<<7)
				STR R1, [R7, #GPIO_OTYPER]
				; Set output speed of pin (01 = 2MHz, 10 = 10MHz)
				LDR R1, [R7, #GPIO_OSPEEDR]		; R1 = GPIOB->OSPEEDR
				BIC R1, R1, #(0x03 << 14)
				ORR R1, R1, #(0x02 << 14)
				STR R1, [R7, #GPIO_OSPEEDR];
				; Set I/O as no pull-up pull-down (00)
				LDR R1, [R7, #GPIO_PUPDR];		; R1 = GPIOB->PUPDR
				BIC R1, R1, #(0x03 << 14)
				STR R1, [R7, #GPIO_PUPDR]			
				;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
				; Set pin PA0 as digital input (00)		
				LDR R7, =GPIOA_BASE				; R1 = GPIOA->MODER
				LDR R1, [R7, #GPIO_MODER]
				BIC R1, R1, #(0x03)
				STR R1, [R7, #GPIO_MODER]
				; Set input type of pin as push-pull (0)
				LDR R1, [R7, #GPIO_OTYPER]		; R1 = GPIOA->OTYPER
				BIC R1, R1, #(0x01)
				STR R1, [R7, #GPIO_OTYPER]
				; Set input speed of pin (01 = 2MHz, 10 = 10MHz)
				LDR R1, [R7, #GPIO_OSPEEDR]		; R1 = GPIOA->OSPEEDR
				BIC R1, R1, #(0x03)
				ORR R1, R1, #(0x02);
				STR R1, [R7, #GPIO_OSPEEDR]
				; Set I/O as no pull-up pull-down (00)
				LDR R1, [R7, #GPIO_PUPDR]		; R1 = GPIOA->PUPDR
				BIC R1, R1, #(0x03)
				STR R1, [R7, #GPIO_PUPDR]

				;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
				; Init LEDs
				;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
				; Turn on BLUE LED (connected to PB6) by setting bit 6 of GPIOB_ODR
				LDR R7, =GPIOB_BASE;
				LDR R1, [R7, #GPIO_ODR];
				ORR R1, R1, #(1<<6);
				STR R1, [R7, #GPIO_ODR];				
				; Turn off GREEN LED (connected to PB7)				
				LDR R7, =GPIOB_BASE;
				LDR R1, [R7, #GPIO_ODR];
				BIC R1,R1, #(1<<7);
				STR R1, [R7, #GPIO_ODR];				
				
				;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
				; MAIN LOOP
				;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
				
loop			LDR R7, =GPIOA_BASE			
				LDR R1, [R7, #GPIO_IDR]		; R1 = GPIOA->IDR
				AND R1,R1, #0x01;			; Check status of pin PA0 (bit 0 of R1)
				CMP R1, #0x01
				BNE loop					; button unpressed
				; Toggle BLUE LED (connected to PB6)
				LDR R7, =GPIOB_BASE;
				LDR R1, [R7, #GPIO_ODR];
				EOR R1, R1, #(1<<6);
				STR R1, [R7, #GPIO_ODR];
				; Toggle GREEN LED (connected to PB7)
				LDR R7, =GPIOB_BASE;
				LDR R1, [R7, #GPIO_ODR];
				EOR R1, R1, #(1<<7);
				STR R1, [R7, #GPIO_ODR];				
				B   loop

				ENDP
				END