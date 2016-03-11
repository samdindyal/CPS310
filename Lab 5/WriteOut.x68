*-----------------------------------------------------------
* Title      :
* Written by :
* Date       :
* Description:
*-----------------------------------------------------------
    ORG    $1000
START:                  ; first instruction of program

* Put program code here
    bsr     open_file
    bsr     write_array
    bsr     close_file

    SIMHALT             ; halt simulator

open_file   lea     file,a1
            move.w  #52,d0
            trap    #15
            rts
            
write_array 
             move.l  array_size,counter            
             move.l  #4,d2
             lea     array,a1

loop:   tst.l   counter   
        ble     done_loop
        move.w  #54,d0
        trap    #15
        addq.l  #4,a1

        subq.l  #1,counter
        bra     loop

done_loop:  rts

close_file  move.w  #50,d0
            trap    #15
            rts

* Put variables and constants here
    ORG     $2000
array        dc.l    1,2,3,4,5
array_size   dc.l    5
file         dc.b    'file',0
counter      dc.l    0
    END    START        ; last line of source


*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
