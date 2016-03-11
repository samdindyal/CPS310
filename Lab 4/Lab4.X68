*-----------------------------------------------------------
* Title      :  CPS310, Lab 4
* Written by :  Sam Dindyal
* Date       :  April 2015
* Description:  An M68000 program which writes an unsorted
*               array of signed integers to a file. It then
*               reads the file it created back into an 
*               array and sorts it using bubble sort.
*-----------------------------------------------------------
    ORG    $1000
START:           
    jsr     backup_registers      
    jsr     write_array_to_file
    jsr     restore_registers
    
    jsr     backup_registers
    jsr     read_array_from_file
    jsr     sort
    jsr     write_array_to_file
    jsr     restore_registers
 
    SIMHALT
    
* Sort the array stored in "array" using bubble sort
sort    ; Clear d0
        clr.l   d0  ; Using d0 as the counter for the outer loop
outer_loop      ; Loop until d0 and the array size are equal
                cmp.b   array_size,d0
                beq     done_outer_loop 
                
                ;Move the array size into d1
                move.b  array_size,d1   ; Using d1 as the counter for the inner loop
                ext.l   d1
                sub.l   #1,d1               
                
                ; Subtract the current counter from the outer loop from the counter of the inner loop
                sub.l   d0,d1                
                
                ; Increment the counter for the outer loop
                add.l   #1,d0

                ; Reset the address registers a0 and a1
                jsr     set_address_registers                
        
inner_loop:     ; Loop until d1 is 0
                tst.l   d1
                ble     outer_loop
        
                ; Decrement the counter for the inner loop
                sub.l   #1,d1
        
                ; Compare the two current values of the array
                cmpm.l  (a1)+,(a0)+
                
                ; Swap if the succeeding value is larger
                bgt     swap
                
                ; Branch to the inner loop 
                bra     inner_loop
        
done_outer_loop:    ; Return to sender
                    rts
            
* Swap the values at the memory address locations of a0 and a1 with the use of the stack.
swap
        ; Move a0 to the stack with auto decrement
        move.l  -4(a0),-(sp)
        
        ; Move the value a1 into the address of a0
        move.l  -4(a1),-4(a0)
        
        ; Move the old value from a0 from the stack to the address of a1
        move.l  (sp)+, -4(a1)
        
        ; Branch back to the inner loop
        bra     inner_loop
        
* Set the address registers, a0 and a1, to the first and second element of "array" respectively.
set_address_registers
                          ; Load the effective address of the array into a0
                          lea       array,a0
                          
                          ; Load the effective address of the array into a1
                          lea       array,a1
                          
                          ; Advance a1 by one long
                          add.l     #4,a1
                          
                          ; Return to sender
                          rts   
                          
* Open a file denoted by the "file" constant.
open_file
            ; Load the effective address of "file" into a1
            lea     file,a1
            
            ; Open a new file with the appropriate trap sequence
            move.l  #52,d0
            trap    #15
            
            ; Return to sender
            rts
            
* Close all open files.
close_file  ; Close all open files
            move.l  #50,d0
            trap    #15
            
            ; Return to sender
            rts
            
* Write "array" to "file".
write_array_to_file
                        ; Open a new file
                        jsr     open_file
                        
                        ; Load the effective address of the array into a1
                        lea     array,a1    ; Use the array as the buffer register
                        
                        ; Prepare registers and counter for reading in "file"
                        move.l  #4,d2
                        move.b  array_size,d3
                        ext.l   d3
                        
write_loop:     ; Loop until d3 is 0
                tst.l   d3
                beq     done_write_loop
                
                ; Write to "file" from "array"
                move.l  #54,d0
                trap    #15
                
                ; Traverse through the array
                add.l   #4,a1
                
                ; Decrement the counter
                sub.l   #1,d3
                
                ; Branch to the write loop
                bra     write_loop
                
done_write_loop:    ; Return to sender
                    rts

* Read an array from "file" and store it into "array".
read_array_from_file    ; Load the effective address of "file" into a1
                        lea     file,a1
                        
                        ; Open existing file
                        move.l  #51,d0
                        trap    #15
                        
                        ; Load the effective address of "array" into a1
                        lea     array,a1    ; Use a1 as the buffer register
                        move.b  array_size,d3   ; Use d3 as the counter for the read loop
                        ext.l   d3
                        
read_loop:  ; Loop until d3 is 0
            tst.l   d3
            beq     done_read_loop 
                  
            ; Prepare registers for a read in
            move.l  #4,d2   ; Reading in size 4 (long size)
            move.l  #53,d0
            
            ; Decrement the counter
            sub.l   #1,d3
            
            ; Read in from file and store into array
            trap    #15
            
            ; Advance to the next element in the array
            add.l   #4,a1
            
            ; Branch to the read loop
            bra     read_loop
  
done_read_loop:     ; Return to sender
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
array       dc.l    7,4,2,9,8
array_size  dc.b    5
file        dc.b    'file',0

    END    START        ; last line of source




*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
