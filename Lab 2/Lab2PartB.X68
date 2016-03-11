*-----------------------------------------------------------
* Title      :  CPS310 - Lab2, Part A2
* Written by :  Sam Dindyal
* Date       :  February 2015
* Description:  A simple code that takes in two values and displays their difference.
*-----------------------------------------------------------
    ORG    $1000
START:                  ; first instruction of program

* Put program code here
   MOVE.L   #4,D0
   TRAP     #15
   MOVE.L   D1,D3
   TRAP     #15
   SUB.L    D1,D3
   MOVE.L   D3,D1
   MOVE.L   #20,D0
   TRAP     #15
        
* Put variables and constants here
VAL     EQU     $2000

    END    START        ; last line of source




*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
