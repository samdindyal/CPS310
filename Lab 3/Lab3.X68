*-----------------------------------------------------------
* Title      :  CPS310, Lab 3
* Written by :  Sam Dindyal
* Date       :  April 2015
* Description:  An M68000 program which takes in two
*               numbers, a and b, and evaluates and prints
*               the solution to the following expression:
*               x = 3a + sqrt(2b)
*-----------------------------------------------------------
    ORG    $1000
START:  
    jsr     backup_registers
    jsr     process_input
    jsr     quad
    jsr     print_solution
    jsr     restore_registers
    
    SIMHALT             ; halt simulator

* Take in 2 numbers, representing a and b, from the keyboard and store them onto the stack.
process_input   ; Load the effective address of the first dialog message into a1
                lea     dialog_message1,a1
                
                ; Print the null terminated ASCII string without a line feed or carriage return
                move.l  #14,d0
                trap    #15
                
                ; Take in a signed integer from the keyboard and store it into d1
                move.l  #4,d0
                trap    #15
                
                ; Move the signed integer from d1 to the stack with auto decrement
                move.l  d1,-(sp)
                
                ; Load the effective address of the second dialog message into a1
                lea     dialog_message2,a1
                
                 ; Print the null terminated ASCII string without a line feed or carriage return
                move.l  #14,d0
                trap    #15
                
                ; Take in a signed integer from the keyboard and store it into d1
                move.l  #4,d0
                trap    #15
                
                ; Place the signed integer in d1 onto the stack with auto decrement
                move.l  d1,-(sp)
                
                ; Put the program counter back on the stack
                move.l  8(sp),-(sp)
                
                ; Return to sender
                rts

* Solve the expression with the a and b values retrieved from the stack.                
quad    ; Clear d0 and d1
        clr.l   d0  ; d0 is our counter
        clr.l   d1
        
        ; Move 3 into d0
        move.l  #3,d0
        
loop1:  ; Loop until d0 is greater than 0 
        tst.l   d0
        ble     done_loop1
        
        ; Add "a" from the stack to d1
        add.l   8(sp),d1
        
        ; Decrement the counter
        sub.l   #1,d0
        
        ; Branch back to loop1
        bra loop1
        
done_loop1:     ; Overwrite a with the result from loop1, 3a, on the stack
                move.l  d1,8(sp)
                
                ; Clear d0 and d1
                clr.l   d0
                clr.l   d1
                
                ; New counter is 2
                move.l  #2,d0

loop2:  ; Loop until d0 is greater than 2 
        tst.l    d0
        ble done_loop2
        
        ; Add "b" from the stack to d1
        add.l   4(sp),d1

        ; Decrement the counter
        sub.l   #1,d0
        
        ; Branch back to loop2
        bra loop2

done_loop2: ; Clear d0, d2, d3
            clr.l   d0
            clr.l   d2  ; We are using d2 for obtaining odd numbers
            clr.l   d3  ; We are using d3 for the summation of the odd numbers obtained from incrementing d2
            
            ; Prepare for summation of odd numbers
            move.l  #1,d2

loop3:  ; Loop until d1 is less than or equal to d3
        cmp.l   d3,d1
        ble     done_loop3
        
        ; Increment d0
        add.l   #1,d0
        
        ; Increment d2 to the next odd number
        add.l   #2,d2
        
        ; Accumulate the summation of odd numbers with the next odd number
        add.l   d2,d3
        
        ; Branch back to loop3
        bra loop3
        
done_loop3:   ; Replace the old b value with sqrt(2b) on the stack
              move.l  d0,4(sp)
       
       ; Add 3a and sqrt(2b) and store the solution in d0
        add.l    8(sp),d0
        
        ; Place the solution from d0 onto the stack
        move.l    d0,-(sp)
            
        ; Put the program counter back
        move.l    4(sp),-(sp)
        
        ;Return to sender
        rts
              
* Print the solution retrieved from the stack from the "quad" subroutine.           
print_solution  ; Load the effective address of the solution message into a1
                lea     solution_message, a1
                
                ; Print the null terminated ASCII string without a line feed or carriage return
                move.l  #14,d0
                trap    #15
                
                ; Move the solution from the stack into d1
                move.l  4(sp),d1
                
                ; Print the signed integer from d1 on the screen
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
dialog_message1     dc.b    'Please enter a value for a: ',0
dialog_message2     dc.b    'Please enter a value for b: ',0
solution_message    dc.b    'The solution is: ',0


    END    START        ; last line of source


*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
