ORG 100H

.DATA

DIGITS	DB 00111111B, 00000110B, 01011011B, 01001111B, 01100110B, 01101101B, 01111101B, 00000111B, 01111111B, 01101111B       

LETTERU DB 00111110B                                                                                                                    
LETTERC DB 00111001B 

CHAR DB 01000000B    

USERNUMBER DB 'ENTER A NUMBER BETWEEN 0-9 = ' 
WINMSG DB 'YOU WIN : 0'
GUESS DB 'TOTAL GUESS : 0'  
NUMBERASSTRING DB '$$$$$$$$'

.CODE 

MOV BL, 0 
MOV BP, 0 


;SET DISPLAY
MOV DX, 2030H
MOV AL, LETTERU    
OUT DX, AL   
INC DX       
MOV AL, CHAR 
OUT DX, AL    

MOV DX, 2035H
MOV AL, LETTERC 
OUT DX, AL
INC DX
MOV AL, CHAR 
OUT DX, AL   
                                
	MOV DX, 2040H	
	MOV SI, 0
	MOV CX, 11

YOUWINPRINT:
	MOV AL, WINMSG[SI]
	OUT DX,AL    
	INC SI
	INC DX

	LOOP YOUWINPRINT

MOV DX, 2050H	
MOV SI, 0       
MOV CX, 15        
	
TOTALGUESSPRINT:
	MOV AL, GUESS[SI]
	OUT DX,AL  
	INC SI
	INC DX

	LOOP TOTALGUESSPRINT
   
START:
    LEA SI, USERNUMBER 
    MOV CX, 29      
    MOV AH, 0EH     
      
WRITE: LODSB
    INT 10H          
    LOOP WRITE
            
    MOV AH,1         
    INT 21H          
    CALL NEWLINE 
    CMP AL, 30H       
    JL START         
    CMP AL, 39H      
    JG START          
      
MOV DX, 2032H         
MOV AH, 0            
MOV SI, AX             

SUB SI, 30H          
MOV AL, DIGITS[SI]  
OUT DX, AX           

CALL GETRANDOM

CMP SI, DX          
PUSH DX              

JNE PROPER
   
    INC BL           
    MOV AL, BL       
    MOV AH, 0        
    
    MOV SI, OFFSET NUMBERASSTRING
    CALL NUMBER2STRING 
    MOV CX, 8         
    MOV DX, 2048H      	
    CALL WRITENUMBER
    
	OUT DX,AL
    
PROPER:
   
    INC BP
    MOV AX, BP      
    
    MOV  SI, OFFSET NUMBERASSTRING
    CALL NUMBER2STRING
    MOV CX, 8     
    MOV DX, 205CH   
    CALL WRITENUMBER 
	OUT DX,AL

MOV     AX, @DATA
MOV     DS, AX
MOV     ES, AX      
    
POP DX             
MOV SI, DX         
MOV AL, DIGITS[SI] 
MOV DX, 2037H     
OUT DX,AL         

LOOP START
RET

GETRANDOM:
   MOV AH, 00H          
   INT 1AH            
              
   MOV AX, DX
   MOV DX, 0H
   MOV CX, 10    
   DIV CX       
RET   
                              
NEWLINE:
    
    PUSH AX     
    MOV DX,13   
    MOV AH,2
    INT 21H     
    MOV DX,10   
    MOV AH,2
    INT 21H
    POP AX      
RET  

NUMBER2STRING PROC   
    
  CALL DOLLARS 
  MOV  BX, 10 
  MOV  CX, 0   
CYCLE1:       
  MOV  DX, 0   
  DIV  BX      
  PUSH DX      
  INC  CX      
  CMP  AX, 0   
  JNE  CYCLE1  
  
CYCLE2:  
  POP  DX       
  ADD  DL, 30H  
  MOV  [SI], DL
  INC  SI
  LOOP CYCLE2  

  RET     
  
NUMBER2STRING ENDP  

PROC DOLLARS  
                   
  MOV  CX, 8
  MOV  DI, OFFSET NUMBERASSTRING  
  
DOLLARS_LOOP:     
 
  MOV  BL, 24H                                                                                                              
  MOV  [DI], BL
  INC  DI
  LOOP DOLLARS_LOOP

  RET
ENDP           

WRITENUMBER   PROC
	MOV SI, 0     
NEXT:
	MOV AL, NUMBERASSTRING[SI]  
	OUT DX,AL                   
	INC SI                      
	CMP NUMBERASSTRING[SI], 24H 
	RET ;JE RET OLMALI
	INC DX

	LOOP NEXT   	
RET