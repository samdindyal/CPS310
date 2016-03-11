*-----------------------------------------------------------
* Title      :
* Written by :
* Date       :
* Description:
*-----------------------------------------------------------
    ORG    $1000
START:                  ; first instruction of program

* Put program code here

    move.l  #file,-(sp)
    bsr open_file
    bsr read_file
    bsr close_file
    
    move.w  #4,d0
    trap    #15
    move.l  d1,-(sp)

    bsr binary_search
    SIMHALT             ; halt simulator

open_file   move.l  4(sp),a1
            move.w  #51,d0
            trap    #15
            rts
            
close_file  move.w  #50,d0
            trap    #15
            rts

read_file   move.l  array_size,counter
            lea     array,a1
            
loop:       tst.l   counter
            ble     done_loop


            move.w  #4,d2
            move.w  #53,d0
            trap    #15
            addq.l  #4,a1
            
            sub.l   #1,counter
            bra     loop

done_loop:  rts

found       lea      found_message,a1
            move.w  #13,d0
            trap    #15
            bra     done_loop

not_found   lea     not_found_message,a1
            move.w  #13,d0
            trap    #15
            bra     done_loop
            
set_middle  move.l  upper_bound,d2
            add.l   lower_bound,d2            
            divs.w  #2,d2
            swap    d2
            clr.w   d2
            swap    d2
            move.l  d2,middle
            rts

set_bounds  move.l  array_size,upper_bound
            move.l  #0,lower_bound
            rts

go_lower    move.l  middle,upper_bound
            subq.l  #1,upper_bound
            bra     search_loop

go_higher   move.l  middle,lower_bound
            addq.l  #1,lower_bound
            bra     search_loop
            
set_offset  move.l  middle,d2
            muls.w  #4,d2
            move.l  d2,offset
            rts


binary_search       move.l  4(sp),d0
                    bsr     set_bounds
                    bsr     set_middle
                    
search_loop:        move.l  lower_bound,d1
                    cmp.l   upper_bound,d1  
                    bgt     not_found

                    lea     array,a0
                    bsr     set_middle
                    bsr     set_offset
                    add.l   offset,a0
                    
                    cmp.l   (a0),d0
                    beq     found

                    cmp.l   (a0),d0
                    blt     go_lower

                    cmp.l   (a0),d0
                    bgt     go_higher

                    bra     search_loop


done_search:        rts                    


* Put variables and constants here
     ORG $2000
file        dc.l    'file',0
array       ds.l    5
array_size  dc.l    5
counter     dc.l    0

upper_bound     dc.l    0
lower_bound     dc.l    0
middle          dc.l    0
offset          dc.l    0

found_message       dc.l    'Found!',0
not_found_message   dc.l    'Not found!',0

    END    START        ; last line of source

*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
