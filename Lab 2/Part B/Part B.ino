/*  Title:         CPS310, Lab 2, Part B
 *  Written By:    Sam Dindyal
 *  Date Written:  April 2015
 *  Description:    A small piece of code which toggles 4 LEDs at different rates on and off on an Arduino Uno.
 */ 

#include <TimedAction.h>

//Global variables
const int LEDS[4] = {0, 1, 2, 3};            //LED locations
const int DELAYS[4] = {500, 200, 250, 275};  //Corresponding LED delays
int led;                                     //Current LED


//Timed actions to turn each LED on
TimedAction led_on[4] = {TimedAction(DELAYS[0], turn_on_LED),
                              TimedAction(DELAYS[1], turn_on_LED),
                              TimedAction(DELAYS[2], turn_on_LED),
                              TimedAction(DELAYS[3], turn_on_LED)};
                              
//Timed actions to turn each LED off                              
TimedAction led_off[4] = {TimedAction(DELAYS[0], turn_off_LED),
                              TimedAction(DELAYS[1], turn_off_LED),
                              TimedAction(DELAYS[2], turn_off_LED),
                              TimedAction(DELAYS[3], turn_off_LED)};

void setup() { 
  //Set initial value of led
  led = 0; 
  
  int i;    //Incremental value
  
   //Loop through and set the pin mode of all LEDs to on
  for (i = 0; i < 4; i++)
    pinMode(LEDS[i], OUTPUT);     
}

void loop() {
  int i;   //Incremental value
  
  //Loop through and toggle each led while updating the "led" variable
  for (i = 0; i < 4; i++)
  {
    led_on[i].check();
    led = i;
    led_off[i].check();
  }
}

/*  Method Signature:    turn_on_LED()
 *  Description:         Turn on the LED corresponding to the "led" global variable.
 */
void turn_on_LED()
{
   digitalWrite(LEDS[led], HIGH);
}

/*  Method Signature:    turn_off_LED()
 *  Description:         Turn off the LED corresponding to the "led" global variable.
 */
void turn_off_LED()
{
   digitalWrite(LEDS[led], LOW);
}
