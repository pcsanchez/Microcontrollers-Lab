RADIX DEC ; SET DECIMAL AS DEFAULT BASE 
PROCESSOR 18F45K50 ; SET PROCESSOR TYPE 
#INCLUDE <p18f45k50.inc> 
; 
;
; VARIABLE'S DEFINITION SECTION 
; 
DIRE	EQU 0

MAIN:
    MOVLB 15
    CLRF ANSELB, BANKED
    CLRF TRISB
    CLRF LATB
    
    CLRF ANSELC, BANKED
    CLRF TRISC
    CLRF LATC
    
    CLRF ANSELD, BANKED
    CLRF TRISD
    
    MOVLW   b'01110010'
    MOVWF   OSCCON
    MOVLW   25
    MOVWF   SPBRG1	; set up baud rate to 9600
    BSF	    TRISC, RX	; configure RX pin for input
    BCF	    TRISC, TX	; configure TX pin for input
    MOVLW   20H
    MOVWF   TXSTA1
    BSF	    RCSTA1, 7	; SPEN
    BSF	    RCSTA1, 4	; CREN
    
    CLRF    DIRE       ;Direccion del motor
    BSF	    DIRE, 1
    MOVFF   DIRE, LATD
    CALL    CONFIGPWM

    
    
loop:
    CALL    GETNUM
    MOVLW   30H
    CPFSGT  LATB
    GOTO    STOP
    MOVLW   31H
    CPFSGT  LATB
    GOTO    v1
    MOVLW   0x32
    CPFSGT  LATB
    GOTO    v2
    MOVLW   0x33
    CPFSGT  LATB
    GOTO    v3
    MOVLW   0x34
    CPFSGT  LATB
    GOTO    v4
    MOVLW   0x35
    CPFSGT  LATB
    GOTO    v5
    MOVLW   0x36
    CPFSGT  LATB
    GOTO    CHANGEDIR
    GOTO    ERRO
    BRA	    LOOP
    
ERRO:
    SETF    LATB
    GOTO    LOOP
    
STOP:
    MOVLW   1
    MOVWF   CCPR1L
    GOTO    LOOP 
    
v1:
    MOVLW   160
    MOVWF   CCPR1L
    GOTO    LOOP
    
v2:
    MOVLW   170
    MOVWF   CCPR1L
    GOTO    LOOP
    
v3:
    MOVLW   180
    MOVWF   CCPR1L
    GOTO    LOOP
    
v4:
    MOVLW   190
    MOVWF   CCPR1L
    GOTO    LOOP
        
v5:
    MOVLW   199
    MOVWF   CCPR1L
    GOTO    LOOP
    
CHANGEDIR:
    BTG	    DIRE,0
    BTG	    DIRE,1
    MOVFF   DIRE,LATD
    GOTO    LOOP
    
    
GETNUM:
    BTFSS   PIR1, 5 
    BRA	    GETNUM
    MOVF    RCREG1, 0	  
    MOVWF   LATB
    RETURN
    
CONFIGPWM:
    MOVLW   199
    MOVWF   PR2	
    MOVLW   1
    MOVWF   CCPR1L
    MOVLW   0CH
    MOVWF   CCP1CON	    
    CLRF    TMR2
    BSF	    T2CON, 2
    RETURN
    
    
    END