*-----------------------------------------------------------
* Title      :
* Written by :
* Date       :
* Description:
*-----------------------------------------------------------
    ORG    $1000
START:                  ; first instruction of program

* Put program code here
        
        bra     loadfile
return
        lea     A,a0
        lea     A,a1
        addq.w  #2,a1
        clr.w   d0
        clr.w   d1
        clr.w   d2
        clr.w   d3
        move.w  arraysize,d1
        bra     sort


finished:        

    SIMHALT             ; halt simulator
    
loadfile
            lea     dir,a1
            move.w  #51,d0
            trap    #15

            move.l  #2,d2
            lea     A,a2
loop1       move.w  #53,d0
            trap    #15

            cmp.w   #1,d0
            beq     doneloop1
            
            cmp.b   #$2D,(a1)
            bne     addtoarray
            bra     loop1


doneloop1

            move.w      d4,arraysize
            move.l      #50,d0
            trap        #15
            
            bra return

addtoarray
            move.l      (a1),(a2)
            sub.w       #$3030,(a2)+
            addq.w      #1,d4
            bra         loop1
            
resetaddressregisters       lea          A,a0
                            lea          A,a1
                            addq.w      #2,a1
                            bra         loop
advance     addq.w  #2,a0
            addq.w  #2,a1
            bra     afteradvance
            
swap        move.w  (a0),temp1
            move.w  (a1),(a0)
            move.w  temp1,(a1)
            bra     afterswap
                            
sort        cmp.w   arraysize,d0
            beq     finished
            move.w  arraysize,d1    
            sub.w   d0,d1

            subq.w  #1,d1
            bra     resetaddressregisters


loop        tst.w   d1
            beq     finishedloop
            
            move.w  (a0),d2
            move.w  (a1),d3

            cmp.w   d2,d3
            blt     swap
afterswap
           bra     advance


afteradvance            
            subq.w  #1,d1
            bra     loop

finishedloop    addq.w  #1,d0
                bra     sort




* Put variables and constants here    
    org     $2000
A            ds.w    20


    org     $2100
arraysize    dc.w    5
temp1        dc.w    0
temp2        dc.w    0
dir          dc.l   'input',0
buffer       dc.w   0

    END    START        ; last line of source


*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
