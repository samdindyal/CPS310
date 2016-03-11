*-----------------------------------------------------------
* Title      :  CPS310 - Lab 2, Part A3
* Written by :  Sam Dindyal
* Date       :  February 2015
* Description:  A simple code that takes in 4 numbers and performed the following and displays the answer: *                num1-num2+num3-num4
*-----------------------------------------------------------
    ORG    $1000
START:                  ; first instruction of program

* Put program code here
    MOVE.L      #4,D0
    TRAP        #15
    MOVE.L      D1,D3
    TRAP        #15
    MOVE.L      D1,NUM2
    TRAP        #15
    MOVE.L      D1,NUM3
    TRAP        #15
    MOVE.L      D1,NUM4
    
    SUB.L       NUM2,D3
    ADD.L       NUM3,D3
    SUB.L       NUM4,D3
    
    MOVE.L      D3,D1
    MOVE.L      #20,D0
    TRAP        #15

* Put variables and constants here
NUM2    EQU     $2000
NUM3    EQU     $2002
NUM4    EQU     $2004
    END    START        ; last line of source

*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
