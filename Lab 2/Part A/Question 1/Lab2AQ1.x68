*-----------------------------------------------------------
* Title      :  CPS310, Lab 2, Part A - Question 1
* Written by :  Sam Dindyal
* Date       :  April 2015
* Description:  An M68000 program which prints the sum of 2 
*               predefined numbers.
*-----------------------------------------------------------
    ORG    $1000
START:                 
    jsr backup_registers
    jsr add_numbers
    jsr print_solution
    jsr restore_registers

    SIMHALT 

* Add num1 and num2 and place the solution on the stack
add_numbers     ; Load num1 into d0
                move.w  num1,d0
                
                ; Extend d0 to long size
                ext.l   d0
                
                ; Add num1 and num2 while storing it in d0
                add.w   num2,d0
                
                ; Store the solution onto the stack and auto decrement
                move.l  d0,-(sp)
                
                ; Put the stack pointer back for rts
                add.l   #4,sp
                
                ; Return to sender
                rts

* Print the solution from the "add_numbers" subroutine
print_solution  ; Fetch the solution from the "add_numbers" subroutine from the stack
                move.l  -4(sp),d1
                
                ; Prepare for the trap sequence for printing
                move.l  #3,d0
                
                ; Print the solution
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
    ORG $2000
    
num1    dc.w    2
num2    dc.w    3

    END    START        ; last line of source


*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
