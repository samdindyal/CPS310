*-----------------------------------------------------------
* Title      :  CPS310 - Lab 2, Part A1
* Written by :  Sam Dindyal
* Date       :  February 2015
* Description:  A short program that adds two predefined numbers then displays the result.
*-----------------------------------------------------------
    ORG    $1000
START:                  ; first instruction of program

* Put program code here

    MOVE.L  #20,D0
    MOVE.L  VAL1,D1
    ADD.L   VAL2,D1    
    TRAP    #15
    
VAL1    DC.L    5
VAL2    DC.L    2
    END     START        ; last line of source












*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
