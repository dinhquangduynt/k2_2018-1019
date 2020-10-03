				INCLUDE stm32l1xx_constants.s		; Load Constant Definitions
				INCLUDE stm32l1xx_tim_constants.s   ; TIM Constants

				AREA    main, CODE, READONLY
				EXPORT	__main						; make __main visible to linker
				ENTRY
				
__main	PROC
				
				BL GPIO_CLOCK_ENABLE	
				BL SysTick_Initialization
				
				; Turn oFF LED connected to pin PC10
				LDR r7, =GPIOC_BASE
				LDR r1, [r7, #GPIO_ODR]
				BIC r1, r1, #(1<<10)
				STR r1, [r7, #GPIO_ODR]
				
				; Turn oFF LED connected to pin PC12
				LDR r7, =GPIOC_BASE
				LDR r1, [r7, #GPIO_ODR]
				BIC r1, r1, #(1<<12)
				;ORR r1,r1,#(1<<12) 
				STR r1, [r7, #GPIO_ODR]
				
				
loop			LDR R7, =GPIOD_BASE			
				LDR R1, [R7, #GPIO_IDR]		; R1 = GPIOD->IDR
				AND R1,R1, #(0x01<<2);			; Check status of pin PD2 (bit 0 of R1)
				CMP R1, #(0x01<<2)
				BNE loop					; button unpressed
				
				; Toggle LED 1 (connected to PC10)
				LDR R7, =GPIOC_BASE;
				LDR R1, [R7, #GPIO_ODR];
				EOR R1, R1, #(1<<10);
				STR R1, [R7, #GPIO_ODR];
				
				
				;Toggle LED 2 (Connected to PC12)
				LDR r7, =GPIOC_BASE
				LDR r1, [r7, #GPIO_ODR]
				EOR r1, r1, #(1<<12)
				STR r1, [r7, #GPIO_ODR]
				
								
stop 		
				MOV r0,#30000 ; delay 3s
				BL delay
				BL reverseLed
				MOV r0,#10000 ; delay 1s
				BL delay
				BL reverseLed
				B 		stop     					; dead loop & program hangs here

				ENDP
					
GPIO_CLOCK_ENABLE PROC
				
				
				LDR r7, =RCC_BASE 					;nap dia chi co so cua thanh ghi rcc vao thanh ghi r7
				LDR r1, [r7, #RCC_AHBENR] 			; nap gia tri tai dia chi tuyet doi co dia chi co so la thanh ghi r7 cong voi dia chi offset tai tai thanh ghi rcc_ahbenr
				ORR r1, r1, #0x00000004				;enable the clock to GPIO port C set bit thu 2 cua thanh ghi r1 len 1
				STR r1, [r7,#RCC_AHBENR]			; luu gia tri tai thanh ghi r1 vao thanh ghi co dia chi tuyet doi la dia chi cua thanh ghi r7 cong voi thanh ghi co dia chi offset la rcc_ahbenr
				
				
				LDR r7, =RCC_BASE ;
				LDR r1, [r7, #RCC_AHBENR] 
				ORR r1, r1, #0x00000008				;enable the clock to GPIO port D
				STR r1, [r7,#RCC_AHBENR]	
				
				
				; PC10
				LDR r7, =GPIOC_BASE
				LDR r1, [r7, #GPIO_MODER]
				BIC r1, r1, #(0x03<<20)			
				ORR r1, r1, #(0x01<<20)				;Set pin 6,7 as digital output (01)
				STR r1, [r7, #GPIO_MODER]	
				
				LDR r1, [r7, #GPIO_OTYPER]
				BIC r1, r1, #(1<<10)				;set output type of pin 6,7  as push-pull 
				STR r1, [r7, #GPIO_OTYPER]
				
				LDR r1, [r7, #GPIO_OSPEEDR]
				BIC r1, r1, #(0x03<<20)				;Speed mask
				ORR r1, r1, #(0x01<<20)				;set I/0 output speed  value as 2 Mhz 01	
				STR r1, [r7, #GPIO_OSPEEDR]
				
				LDR r1, [r7, #GPIO_PUPDR]
				BIC r1, r1, #(0x03<<20)
				ORR r1, r1, #(0x00<<20)				;no pull-up, no pull-down
				STR r1, [r7, #GPIO_PUPDR]		

				;PC12
				; Set pin PC12 as digital output (01)
				LDR R7, =GPIOC_BASE;
				LDR R1, [R7, #GPIO_MODER]		; R1 = GPIOC->MODER
				BIC R1, R1, #(0x03 << 24)
				ORR R1, R1, #(0x01 << 24)
				STR R1, [R7, #GPIO_MODER]
				; Set output type of pin as push-pull (0)
				LDR R1, [R7, #GPIO_OTYPER]		; R1 = GPIOC->OTYPER
				BIC R1, R1, #(1<<12)
				STR R1, [R7, #GPIO_OTYPER]
				; Set output speed of pin (01 = 2MHz, 10 = 10MHz)
				LDR R1, [R7, #GPIO_OSPEEDR]		; R1 = GPIOC->OSPEEDR
				BIC R1, R1, #(0x03 << 24)
				ORR R1, R1, #(0x02 << 24)
				STR R1, [R7, #GPIO_OSPEEDR]
				; Set I/O as no pull-up pull-down (00)
				LDR R1, [R7, #GPIO_PUPDR]		; R1 = GPIOC->PUPDR
				BIC R1, R1, #(0x03 << 24)
				STR R1, [R7, #GPIO_PUPDR]
				
				; PD2
				; Set pin PD2 as digital input (00)		
				LDR R7, =GPIOD_BASE				; R1 = GPIOD->MODER
				LDR R1, [R7, #GPIO_MODER]
				BIC R1, R1, #(0x03<<4)
				STR R1, [R7, #GPIO_MODER]
				; Set input type of pin as push-pull (0)
				LDR R1, [R7, #GPIO_OTYPER]		; R1 = GPIOD->OTYPER
				BIC R1, R1, #(0x01<<2)
				STR R1, [R7, #GPIO_OTYPER]
				; Set input speed of pin (01 = 2MHz, 10 = 10MHz)
				LDR R1, [R7, #GPIO_OSPEEDR]		; R1 = GPIOD->OSPEEDR
				BIC R1, R1, #(0x03<<4)
				ORR R1, R1, #(0x02<<4);
				STR R1, [R7, #GPIO_OSPEEDR]
				; Set I/O as no pull-up pull-down (00)
				LDR R1, [R7, #GPIO_PUPDR]		; R1 = GPIOD->PUPDR
				BIC R1, R1, #(0x03<<4)
				STR R1, [R7, #GPIO_PUPDR]
				
				BX lr				
				ENDP
					
SysTick_Initialization PROC
				
				;set tan so xung nhip 4.194Mhz 110, 2.097 101
				LDR r1,=RCC_BASE
				LDR r2,[r1,#0x04]
				BIC r2,r2,#(7<<13)
				ORR r2,r2,#(6<<13)
				STR r2,[r1,#0x04]
	
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
				LDR r3,=418
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
				
				;Set sysTick CTRL to enable SysTick timer and SysTick interrupt 
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
loop1 		CMP r10,#0		;wait for TimingDelay
			BNE loop1		;r10 is decreased periodically by SysTick_Handler			
			BX lr			
			ENDP
	
reverseLed	PROC		
				;pc10
				LDR r7, =GPIOC_BASE
				LDR r1, [r7, #GPIO_ODR]
				EOR r1, r1, #(1<<10)
				STR r1, [r7, #GPIO_ODR]	
				
				BX lr
				ENDP

				END