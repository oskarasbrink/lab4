jmp RESET
jmp INT0_MUX

.org $2A 
 clr r17
 ldi r17, $08
 RESET:;avbrott
	ldi r16,$0F
	out MCUCR,r16 ; set int0 och int1 att interrupta stigande
	ldi r16,(1<<INT0)
	out GICR,r16
;portar
 

 
 clr r19
 ser r16
 out DDRB, r16
 ;stack
 ldi r16, HIGH(RAMEND)
 out SPH, r16
 ldi r16, LOW(RAMEND)
 out SPL, r16
 ;a/d
	ldi r16, (1<<ADLAR)
	out ADMUX, r16

	ldi r16, (1<<ADEN)
	out ADCSRA, r16
  sei
LOOP:
	 sbi ADCSRA, ADSC
WAIT:
	 sbic ADCSRA, ADSC
	 jmp WAIT
	
  
	 in r16, ADCH

	 cpi r16, $E
	 brlo PLUS

	 cpi r16,$F0
	brsh MINUS
UT:
	out PORTB, r17 
	jmp LOOP

PLUS:
	sbrs r17,0
	lsr r17
	out PORTB,r17
	call DELAY
	jmp UT

MINUS:
	sbrs r17,6
	lsl r17
	out PORTB,r17
	call DELAY
	jmp UT
 
INT0_MUX:;
	

	;andi r19,$06
;	swap r19
;	out PORTA,r19
;	swap r19
	;inc r19
reti



DELAY:

	ldi r20,3
D_3:
	ldi r21,0
D_2:
	ldi r22,0
D_1:
	dec r22
	brne D_1
	dec r21
	brne D_2
	dec r20
	brne D_3
	ret 
