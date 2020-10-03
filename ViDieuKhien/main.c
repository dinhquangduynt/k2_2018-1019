//******************** (C) Yifeng ZHU ********************
// @file    main.c
// @author  Yifeng Zhu
// @version V1.0.0
// @date    November-11-2012
// @note    
// @brief   C code for STM32L1xx Discovery Kit
// @note
//          This code is for the book "Embedded Systems with ARM Cortex-M3 
//          Microcontrollers in Assembly Language and C, Yifeng Zhu, 
//          ISBN-10: 0982692625.
// @attension
//          This code is provided for education purpose. The author shall not be 
//          held liable for any direct, indirect or consequential damages, for any 
//          reason whatever. More information can be found from book website: 
//          http://www.eece.maine.edu/~zhu/book
//********************************************************

#include <stdint.h>

/* Standard STM32L1xxx driver headers */
#include "stm32l1xx.h"

/* STM32L1xx Discovery Kit:
    - USER Pushbutton: connected to PA0 (GPIO Port A, PIN 0), CLK RCC_AHBENR_GPIOAEN
    - RESET Pushbutton: connected RESET
    - GREEN LED: connected to PB7 (GPIO Port B, PIN 7), CLK RCC_AHBENR_GPIOBEN 
    - BLUE LED: connected to PB6 (GPIO Port B, PIN 6), CLK RCC_AHBENR_GPIOBEN
    - Linear touch sensor/touchkeys: PA6, PA7 (group 2),  PC4, PC5 (group 9),  PB0, PB1 (group 3)
*/

// Enable the clock to GPIO Ports A&B
void GPIO_Clock_Enable() {
	RCC->AHBENR |= RCC_AHBENR_GPIOAEN;
	RCC->AHBENR	|= RCC_AHBENR_GPIOBEN;
}

/* Init a pin of Port B as digital output, output type of push-pull */
void GPIO_PortB_Output_Pin_Init(int pinID) {
	// Set pin as digital output (01)
	GPIOB->MODER &= ~(0x03<<(2*pinID));
	GPIOB->MODER |=   0x01<<(2*pinID);
	
	// Set output type of pin as push-pull (0)
	GPIOB->OTYPER &= ~(0x01<<pinID);
	
	// Set pin's output speed (01 = 2MHz, 10 = 10MHz)
	GPIOB->OSPEEDR &= ~(0x03<<(2*pinID)); // Speed mask
	GPIOB->OSPEEDR |=   0x02<<(2*pinID);
	
	// Set I/O as no pull-up pull-down (00)
	GPIOB->PUPDR &= ~(0x03<<(2*pinID));
}

/* Toggle an output pin of Port B */
void GPIO_PortB_Pin_Toggle(int pinID) {
	GPIOB->ODR ^= 1<<pinID;
}

/* Init a pin of Port A as digital input, input type of push-pull */
void GPIO_PortA_Input_Pin_Init(int pinID) {
	// Set pin as digital input (00)
	GPIOA->MODER &= ~(0x03<<(2*pinID));
	
	// Set output type of pin as push-pull (0)
	GPIOA->OTYPER &= ~(0x01<<pinID);
	
	// Set pin's output speed (01 = 2MHz, 10 = 10MHz)
	GPIOA->OSPEEDR &= ~(0x03<<(2*pinID)); // Speed mask
	GPIOA->OSPEEDR |=   0x02<<(2*pinID);
	
	// Set I/O as no pull-up pull-down (00)
	GPIOA->PUPDR &= ~(0x03<<(2*pinID));
}

/* delay */
void delay(int t) {
	int count = 0;
	while (count < t) {
		count++;
	};
}

//******************************************************************************************
//* The main program starts here:
//* Toggle two LEDs when the user button is pressed.
//******************************************************************************************

/* LED definitions */
#define GREEN_LED 7	// GREEN LED: connected to PB7
#define BLUE_LED  6	// BLUE  LED: connected to PB6

int main(void){
	int pinPA0=0;
	
	GPIO_Clock_Enable();							// Enable the clock for ports A&B
	
	GPIO_PortB_Output_Pin_Init(GREEN_LED); 	// Init the pins attached to the LEDs as digital outputs
	GPIO_PortB_Output_Pin_Init(BLUE_LED); 		
	
	GPIO_PortA_Input_Pin_Init(0);	// Init the pin PA0 attached to the user button as digital input
	
	// turn-on BLUE led, turn-off GREEN led
	GPIOB->ODR  |= 1<<BLUE_LED;
	GPIOB->ODR  &= ~(1<<GREEN_LED);
	
	// Loop forever
	while(1) {		
		if (GPIOA->IDR & 0x01) {		// User button pressed
			while (GPIOA->IDR & 0x01) {} // wait until button released
			GPIO_PortB_Pin_Toggle(GREEN_LED);	// Toggle the green LED
			GPIO_PortB_Pin_Toggle(BLUE_LED);	// Toggle the blue LED			
		}		
	};
}