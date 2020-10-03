				INCLUDE stm32l1xx_constants.s		; Load Constant Definitions
				INCLUDE stm32l1xx_tim_constants.s   ; TIM Constants

				AREA    main, CODE, READONLY
				EXPORT	__main						; make __main visible to linker
				ENTRY
				
__main	PROC
				
				BL GPIO_CLOCK_ENABLE	
				BL SysTick_Initialization
				
				; Turn on LED connected to pin PB6
				LDR r7, =GPIOB_BASE
				LDR r1, [r7, #GPIO_ODR]
				ORR r1, r1, #(1<<6)
				STR r1, [r7, #GPIO_ODR]
				
				MOV r0,#1000				
stop 		
				BL delay
				BL reverseLed
				B 		stop     					; dead loop & program hangs here

				ENDP
					
GPIO_CLOCK_ENABLE PROC
				LDR r7, =RCC_BASE ;
				LDR r1, [r7, #RCC_AHBENR] 
				ORR r1, r1, #0x00000002				;enable the clock to GPIO port B
				STR r1, [r7,#RCC_AHBENR]	
				
				LDR r7, =GPIOB_BASE
				LDR r1, [r7, #GPIO_MODER]
				BIC r1, r1, #(0x0F <<12)			;Clear bit 15 14 13 12
				ORR r1, r1, #(0x05<<12)				;Set pin 6,7 as digital output
				STR r1, [r7, #GPIO_MODER]	
				
				LDR r1, [r7, #GPIO_OTYPER]
				BIC r1, r1, #(3<<6)						;set output type of pin 6,7  as push-pull
				STR r1, [r7, #GPIO_OTYPER]
				
				LDR r1, [r7, #GPIO_OSPEEDR]
				BIC r1, r1, #(0x0F<<12)				;Speed mask
				ORR r1, r1, #(0x05<<12)				;set I/0 output speed  value as 2 Mhz	
				STR r1, [r7, #GPIO_OSPEEDR]
				
				LDR r1, [r7, #GPIO_PUPDR]
				BIC r1, r1, #(0x0F<<12)
				ORR r1, r1, #(0x00<<12)				;no pull-up, no pull-down
				STR r1, [r7, #GPIO_PUPDR]				
				BX lr				
				ENDP
					
SysTick_Initialization PROC
				LDR r1,=RCC_BASE
				LDR r2, [r1,#RCC_ICSCR]
				BIC r2,r2,#(0x07<<13)
				ORR r2,r2,#(0x06<<13)
				STR r2,[r1,#RCC_ICSCR]
				;Set SysTick CTR to disable SysTick IRQ and SysTick timer
				LDR r1,=SysTick_BASE
				
				LDR r2,[r1,#SysTick_CTRL]
				BIC r2,r2,#1								;Clear ENABLE
				STR r2,[r1,#SysTick_CTRL]
				
				LDR r2,[r1,#SysTick_CTRL]
				BIC r2,r2,#0x01<<1					;Disable SysTick interrupt 
				STR r2,[r1,#SysTick_CTRL]
				
				;Select clock source
				;LDR r2,[r1,#SysTick_CTRL]
				;BIC r2,r2,#0x01<<2					;Select external clock 
			    ;STR r2,[r1,#SysTick_CTRL]
				
				LDR r2,[r1,#SysTick_CTRL]
				ORR r2,r2,#0x01<<2					;Select processor clock 
				STR r2,[r1,#SysTick_CTRL]
				
				;Set SysTick_LOAD and specify the number of clock cycles 
				;between two interrupts
				;LDR r3,=262
				LDR r3,=4194
				STR r3,[r1,#SysTick_LOAD]
				
				;Clear SysTick current value register(SysTick_VAL)
				MOV r2,#0
				STR r2,[r1,#SysTick_VAL]
				
				;Set interrupt priority and enable NVIC SysTick interrupt
				LDR r3,=NVIC_BASE
				LDR r4,[r3,#NVIC_ISER0]
				BIC r4,r4,#(0x03<<0x0F)
				ORR r4,r4,#(0x01<<0x0F)
				STR r4,[r3,#NVIC_ISER0]
				
				LDR r4,[r3,#NVIC_IPR0] 
				BIC r4,r4,#0xFF
				STR r4,[r3,#NVIC_IPR0] 
				
				;Set sys Tick CTRL to enable SysTick timer and SysTick interrupt 
				LDR r2,[r1,#SysTick_CTRL]
				ORR r2,r2,#1
				STR r2,[r1,#SysTick_CTRL]
				
				LDR r2,[r1,#SysTick_CTRL]
				ORR r2,r2,#1<<1
				STR r2,[r1,#SysTick_CTRL]			
				BX lr				
				ENDP
					
SysTick_Handler PROC
				EXPORT SysTick_Handler
				;Auto-stacking eight registers r0 - r3, r12, LR, PSR, and PC
				SUB r10,r10,#1				
				BX lr
				ENDP

delay PROC
			;r0 is the TimingDelay input
			MOV r10, r0		;Make a copy of TimingDelay
loop 		CMP r10,#0		;wait for TimingDelay
			BNE loop		;r10 is decreased periodically by SysTick_Handler			
			BX lr			
			ENDP
	
reverseLed	PROC		
				LDR r7, =GPIOB_BASE
				LDR r1, [r7, #GPIO_ODR]
				EOR r1, r1, #(3<<6)
				STR r1, [r7, #GPIO_ODR]	
				
				BX lr
				ENDP

				END
