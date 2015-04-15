*-----------------------------------------------------------
* Title      :  CPS310, Lab 5
* Written by :  Sam Dindyal
* Date       :  April 2015
* Description:  An M68000 program which reads in a sorted 
*               array from a file and a signed integer from 
*               the keyboard. It then searches through that
*               array using binary search and displays an
*               ASCII string depending on whether the 
*               number has been found or not.
*-----------------------------------------------------------
    ORG    $1000
START:                  ; first instruction of program

    jsr     backup_registers
    
    jsr     read_array_from_file
    
    jsr     process_input
    jsr     prepare_for_search
    jsr     search
    
    jsr     restore_registers

    SIMHALT             ; halt simulator

* Search for a number, defined by the search key, in the sorted array "array", using binary search.
search
            ; Recalculate the middle
            jsr     update_middle
            
            ; If the start is larger than the end, the element does not exist in the "array"
            cmp.l   d0,d1
            blt     not_found_finish
            
            ; If the center is equal to the search key, the element has been found
            cmp.l   (a0),d3
            beq     found_finish
            
            ; If the search key is larger than the middle, shift the range up
            cmp.l   (a0)+,d3
            bgt     shift_up
            
            ; if the search key is smaller than the middle, shift the range down
            cmp.l   (a0)+,d3
            blt     shift_down
            
            ; Branch to search
            bra     search
            
* Prints the appropriate message in the event that the search key has been found.
found_finish:
                ; Load the effective address of the found message into a1
                lea     found_message,a1
                
                ; Print the null terminated ASCII string in a1 without a line feed or carriage return
                move.l  #13,d0
                trap    #15
                
                ; Return to sender
                rts
           
* Prints the appropriate message in the even that the search key has not been found.
not_found_finish:   ; Load the effective address of the not found message into a1
                    lea     not_found_message,a1
                    
                    ; Print the null terminated ASCII string in a1 without a line feed or carriage return
                    move.l  #13,d0
                    trap    #15 
                    
                    ; Return to sender
                    rts

* Shift the range of the search up.
shift_up    ; Move the middle from d2 into the start at d0
            move.l      d2,d0
            
            ; Add 1 to the start
            add.l       #1,d0
            
            ; Branch back to the search
            bra         search
            
* Shift the range of the search down.
shift_down  ; Move the middle from d2 to the end at d1
            move.l      d2,d1
            
            ; Subtract 1 from the end at d1
            sub.l       #1,d1   
            
            ; Branch back to the search
            bra         search
            
* Recalculate the middle value in d2        
update_middle
                    ; Move the end into d2
                    move.l      d1,d2   ; Using d2 for middle
                    
                    ; Divide the contents of d2 by 2
                    divs.w      #2,d2
                    
                    ; Remove the remainder, if there is any
                    ext.l       d2
                    
                    ; Return to sender
                    rts
                    
* Prepare the registers for searching.
prepare_for_search      ; Clear the start
                        clr.l   d0      ; Using d0 for start
                        
                        ; Move the array size into the end
                        move.b  array_size,d1   ; Using d1 for end
                        ext.l   d1
                        
                        ; Load the effective address of the array into a0
                        lea     array,a0        ; Using a0 for the array
                        
                        ; Move the search key into d3
                        move.l  search_key,d3      ; Using d3 for the search key
                        
                        ; Return to sender
                        rts

* Take in a signed integer from the keyboard and store it in the "search_key" variable.
process_input   ; Load the effective address of the dialog message into a1
                lea     dialog_message,a1
                
                ; Print the null terminated ASCII string without a line feed or carriage return
                move.l  #14,d0
                trap    #15
                
                ; Take in a signed integer from the keyboard and store it into d1
                move.l  #4,d0
                trap    #15
                
                ; Move the input from d1 to "search_key"
                move.l  d1,search_key
                
                ; Return to sender
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


* Put variables and constants here
    ORG    $2000
dialog_message      dc.b    'Please enter the number you would like to search for: ',0
found_message       dc.b    'Found!',0
not_found_message   dc.b    'Not found!',0

file                dc.b    'file',0

array       ds.l    5
array_size  dc.b    5
search_key  ds.l    1
    END    START        ; last line of source


*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
