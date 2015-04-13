*-----------------------------------------------------------
* Title      :  CPS310, Lab 2, Part A - Question 2
* Written by :  Sam Dindyal
* Date       :  April 2015
* Description:  An M68000 program which reads two numbers 
*               from the keyboard and prints their 
*               difference on the screen.
*-----------------------------------------------------------
    ORG    $1000
START:                  

    jsr     backup_registers
    jsr     process_input
    jsr     subtract_numbers
    jsr     print_solution
    jsr     restore_registers

    SIMHALT
    
* Retrieve two numbers from the user through the keyboard and store them on the stack. 
process_input   ; Load the effective address of the first dialog message to a1
                lea     dialog_message1,a1
                
                ; Print the null terminated ASCII string in a1 without a carriage return or line feed
                move.l  #14,d0
                trap    #15
                
                ; Take in a number from the keyboard and store it into d1
                move.l  #4,d0
                trap    #15
                
                ; Place the retrieved value and place it on the stack
                move.l  d1,-(sp)

                ; Load the effective address of the second dialog message to a1
                lea     dialog_message2,a1
                
                ; Print the null terminated ASCII string in a1 without a carriage return or line feed
                move.l  #14,d0
                trap    #15
                
                ; Take in a number from the keyboard and store it into d1
                move.l  #4,d0
                trap    #15
                
                ; Place the retrieved value and place it on the stack
                move.l  d1,-(sp)
                
                ; Put the program counter back for resumption
                move.l  8(sp),-(sp)
                
                ; Return to sender
                rts

* Subtract two numbers retrieved from the stack and place the solution onto the stack.
subtract_numbers    ; Retrieve the first number from the stack and put it into d0
                    move.l  8(sp),d0
                    
                    ; Subtract the second number from the first from the stack to d0
                    sub.l   4(sp),d0
        
                    ; Move the solution onto the stack without disrupting the stack pointer                    
                    move.l  d0,-(sp)


                    ; Put the stack pointer back
                    addq.w  #4,sp
                    
                    ; Return to sender
                    rts

* Retrieve the solution from the "subtract_numbers" subroutine from the stack and print it on the screen                    
print_solution      ; Load the effective address of the solution message to a1
                    lea     solution_message,a1
                    
                    ; Print the null terminated ASCII string in a1 without a carriage return or line feed
                    move.l  #14,d0
                    trap    #15
                    
                    ; Fetch the solution from the "subtract_numbers" subroutine from the stack and place it in d1
                    move.l  -4(sp),d1
                    
                    ; Print the signed integer in d1 on the screen
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
    
dialog_message1     dc.b    'Please enter your first number: ',0
dialog_message2     dc.b    'Please enter your second number: ',0
solution_message    dc.b    'The solution is: ',0

    END    START



*~Font name~Courier~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
