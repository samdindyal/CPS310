*-----------------------------------------------------------
* Title      :  CPS310, Lab 2, Part A - Question 3
* Written by :  Sam Dindyal
* Date       :  April 2015
* Description:  An M68000 program which reads in four
*               numbers from the keyboard, solves the 
*               following equation and prints the solution
*               on the screen:
*               
*               num1 - num2 + num3 - num4
*               
*               where the sequence of which the numbers 
*               appear is respective to the order they are
*               entered.
*-----------------------------------------------------------
    ORG    $1000
START:  
    
    jsr     backup_registers
    jsr     process_input
    jsr     calculate
    jsr     print_solution
    jsr     restore_registers

    SIMHALT   

* Retrieve four numbers from the keyboard and store them on the stack.
process_input   ; Load the effective address of the first dialog message into a1
                lea     dialog_message1,a1
                
                ; Print the null terminated ASCII string in a1 without a carriage return or line feed
                move.l  #14,d0
                trap    #15
                
                ; Take in a signed integer from the keyboard and store it into d1
                move.l  #4,d0
                trap    #15
                
                ; Place the signed integer retrieved from the keyboard onto the stack
                move.l  d1,-(sp)

                ; Load the effective address of the second dialog message into a1
                lea     dialog_message2,a1
                
                ; Print the null terminated ASCII string in a1 without a carriage return or line feed
                move.l  #14,d0
                trap    #15
                
                ; Take in a signed integer from the keyboard and store it into d1
                move.l  #4,d0
                trap    #15
                
                ; Place the signed integer retrieved from the keyboard onto the stack
                move.l  d1,-(sp)
                
                ; Load the effective address of the third dialog message into a1
                lea     dialog_message3,a1
                
                ; Print the null terminated ASCII string in a1 without a carriage return or line feed
                move.l  #14,d0
                trap    #15
                
                ; Take in a signed integer from the keyboard and store it into d1
                move.l  #4,d0
                trap    #15
                
                ; Place the signed integer received from the keyboard onto the stack
                move.l  d1,-(sp)

                ; Load the effective address of the fourth dialog message into a1
                lea     dialog_message4,a1
                
                ; Print the null terminated ASCII string in a1 without a carriage return or line feed
                move.l  #14,d0
                trap    #15
                
                ; Take in a signed integer from the keyboard
                move.l  #4,d0
                trap    #15
                
                ; Place the signed integer received from the keyboard onto the stack
                move.l  d1,-(sp)

                ; Restore the program counter from the stack
                move.l 	16(sp),-(sp)

                ; Return to sender
                rts

* Calculate the solution using the formula and the numbers entered by the user and store it on the stack.
calculate   ; Move the first number into d0
            move.l  16(sp),d0

            ; Subtract the second number from the first number and store it in d0
            sub.l   12(sp),d0
            
            ; Add the third number to the contents of d0
            add.l   8(sp),d0
            
            ; Subtract the fourth number from the contents of d0
            sub.l   4(sp),d0
            
            ; Move the completed solution onto the stack with auto decrement
            move.l  d0,-(sp)
            
            ; Put the stack pointer back
            add.l   #4,sp
    
            ; Return to sender
            rts
            
* Print the solution created by the "calculate" subroutine from the stack.
print_solution      ; Load the effective address of the solution message into a1
                    lea     solution_message,a1

                    ; Print the null terminated ASCII string without a carriage return or line feed
                    move.l  #14,d0
                    trap    #15
                    
                    ; Fetch the solution created by the "calculate" subroutine and place it into d1
                    move.l  4(sp),d1
                    
                    ; Print the solution
                    move.l  #3,d0
                    trap    #15
                    
                    ; Return to sender
                    rts

*Backup all registers to the stack using auto decrement
backup_registers    ; Backup address registers to stack with auto decrement
                    move.l  a0,-(sp)
                    move.l  a1,-(sp)
                    move.l  a2,-(sp)
                    move.l  a3,-(sp)
                    move.l  a4,-(sp)
                    move.l  a5,-(sp)
                    move.l  a6,-(sp)
                    move.l  a7,-(sp)
                    
                    ; Backup data registers to stack with auto decrement
                    move.l  d0,-(sp)
                    move.l  d1,-(sp)
                    move.l  d2,-(sp)
                    move.l  d3,-(sp)
                    move.l  d4,-(sp)
                    move.l  d5,-(sp)
                    move.l  d6,-(sp)
                    move.l  d7,-(sp)
                    
                    ; Restore the program counter for resumption
                    move.l  64(sp),-(sp)
                    
                    ; Return to sender
                    rts

* Restore all content to registers using auto increment
restore_registers   add.l   #4,sp

                   ; Restore content from stack to data registers using auto increment
                    move.l  (sp)+,d7
                    move.l  (sp)+,d6
                    move.l  (sp)+,d5
                    move.l  (sp)+,d4
                    move.l  (sp)+,d3
                    move.l  (sp)+,d2
                    move.l  (sp)+,d1
                    move.l  (sp)+,d0
                    
                    ; Restore content from stack to address registers using auto increment
                    move.l  (sp)+,a7
                    move.l  (sp)+,a6
                    move.l  (sp)+,a5
                    move.l  (sp)+,a4
                    move.l  (sp)+,a3
                    move.l  (sp)+,a2
                    move.l  (sp)+,a1
                    move.l  (sp)+,a0
                    
                    ; Put the stack pointer back for the program counter to resume
                    move.l  -68(sp),(sp) 

                    ; Return to sender
                    rts
                
             
* Variables and constants
    ORG    $2000
    
dialog_message1     dc.b    'Please enter your first number: '  ,0
dialog_message2     dc.b    'Please enter your second number: ' ,0
dialog_message3     dc.b    'Please enter your third number: '  ,0
dialog_message4     dc.b    'Please enter your fourth number: ' ,0

solution_message    dc.b    'The solution is: ',0

    END    START        ; last line of source




*~Font name~Courier~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
