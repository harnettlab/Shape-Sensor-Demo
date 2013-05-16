/**
 * CSwitchArm CKH 3_26_13
 * Take a number btw 0 and 255 and interpret this as a series of 8 "on offs"
 * Draw it as an "arm" with 8 arc segments
 * The pattern is easiest to see when you write the incoming byte in 8-bit binary
 * If incoming byte is 0: (binary 00000000) all switches are off
 * If incoming byte is 128: (binary 10000000) only switch 1 is on
 * If incoming byte is 64: (binary 01000000) only switch 2 is on
 * If incoming byte is 128+64: (binary 11000000) switch 1 and 2 are on, all others off
 * ETC, there are 2^8 or 256 possibilities.
 * Now you have to build an Arduino program that will read 8 digital ports and send
 * the corresponding byte. There's a tiny example at the comments at the end of this.
 * To read more than 8 switches, you would need to send another byte.
 */


import processing.serial.*;

Serial myPort;  // Create object from Serial class
int val;      // Data received from the serial port
int[] switchstate=new int[8];
int switchmask = 0;
float arcangle=PI/4;
float arcwidth=100;//width of ellipse used to draw arc
float deltx=(arcwidth/2)*sin(arcangle);
float delty=(arcwidth/2)*(1-cos(arcangle));

void setup() 
{
  size(400, 500);
  // I know that the first port in the serial list on my mac
  // is always my  FTDI adaptor, so I open Serial.list()[0].
  // On Windows machines, this generally opens COM1.
  // Open whatever port is the one you're using.
  String portName = Serial.list()[0];
  myPort = new Serial(this, portName, 9600);
  background(255);
  strokeWeight(5.0);
  smooth();
  textSize(20);
}


//Let's use 0-255 to represent any of 2^8 switch settings for 8 switches.

void draw()
{
  if ( myPort.available() > 0) {  // If data is available,
    val = myPort.read();         // read it and store it in val
    background(255);
    
    //here are some test bytes
    //val=255;//should get a circle
    //val=170;//should get a line 10101010
    //val=85; //the opposite line 01010101
    //val=0;//another circle

    //that's working, I used coolterm on another mac to send 
    //bytes over bluetooth & can see the image change
    fill(255, 0, 0);//text color
    text(binary(val, 8),105, 60); //write what the incoming byte is
    switchmask=128; //now go through and do something with each value
    //switchmask=1 works from the other end of the byte

    translate(width/4,height/2); //get ready to draw some arcs starting at the center
    
    for (int k=0;k<8;k++) {  
      noFill(); //draw just a line for the arc
      if ((val & switchmask) !=0){//if there's an "on" at switch k
         switchstate[k]=1;//save it for some reason, may be useful 
         stroke(0,75,128);//blue color
         arc(0,-arcwidth/2,arcwidth,arcwidth,HALF_PI-arcangle, HALF_PI);
         
         //Make nice labels
         fill(128,128,128);//text color
         rotate(-arcangle/2);
         text(str(k+1),deltx/2-5,-5);//label the arcs according to switch position
         rotate(arcangle/2);
         //done with labels
         
         translate(deltx,-delty);
         rotate(-arcangle);
       }
      else{//arc has the other orientation
         switchstate[k]=0;//there's an "off" at switch k
         stroke(200,120,0);//orange color
         arc(0,arcwidth/2,arcwidth,arcwidth,3*HALF_PI,3*HALF_PI+arcangle);
         
         //Make nice labels
         fill(128,128,128);//text color
         rotate(arcangle/2);
         text(str(k+1),deltx/2-5,-10);//label the arcs according to switch position
         rotate(-arcangle/2);
         //done with labels
         
         translate(deltx,delty);
         rotate(arcangle);

      } 
       
       //switchmask=switchmask << 1;//look at next bit next time thru, works in opposite direction
       switchmask=switchmask >>1; //work towards lsb at end of chain--this makes a neater movie since center of chain stays still as I flip lsbits
      
    }
    translate(0,0); //get back to normal
  }
}



/*

 // Wiring / Arduino Code
 // Code for sensing a switch status and writing the value to the serial port. Would need to modify it to read 8 bits and compose a byte--CKH.
 //To get the byte I would read a port for switch 1, add a 1, shift it over and add a 1 or 0 for the next port, shift << etc. up to byte 7 
 
 int switchPin = 4;                       // Switch connected to pin 4
 
 void setup() {
 pinMode(switchPin, INPUT);             // Set pin 0 as an input
 Serial.begin(9600);                    // Start serial communication at 9600 bps
 }
 
 void loop() {
 if (digitalRead(switchPin) == HIGH) {  // If switch is ON,
 Serial.print(1, BYTE);               // send 1 to Processing
 } else {                               // If the switch is not ON,
 Serial.print(0, BYTE);               // send 0 to Processing
 }
 delay(100);                            // Wait 100 milliseconds
 }
 
 */
