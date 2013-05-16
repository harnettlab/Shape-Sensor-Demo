/*
 Cbyte CKH 3-27-13
 Reads a digital input on pins 2,3,4,5,6,7,8,9, 
 Sends byte with MSB=1 if port 2 is high, 
 LSB=1 if switch 9 is on
 etc in between
 */
int i=0;
byte outbyte=0;

void setup() {
  Serial.begin(9600);
  // make pins 2-9 input:
  pinMode(2, INPUT);
  pinMode(3, INPUT);
  pinMode(4, INPUT);
  pinMode(5, INPUT);
  pinMode(6, INPUT);
  pinMode(7, INPUT);
  pinMode(8, INPUT);
  pinMode(9, INPUT);
  
  digitalWrite(2,HIGH);//turn on pullup resistors on all these pins
  digitalWrite(3,HIGH);
  digitalWrite(4,HIGH);
  digitalWrite(5,HIGH);
  digitalWrite(6,HIGH);
  digitalWrite(7,HIGH);
  digitalWrite(8,HIGH);
  digitalWrite(9,HIGH);
 
}

void loop() {
  // read the input pins:
  outbyte=0;
  for (i=2;i<10;i++){
     outbyte = outbyte*2;  //or left shift, outbyte = outbyte << 1
     if (digitalRead(i)==HIGH) {
       outbyte=outbyte + 1; //then add one to the least-significant position if switch is on
     }
  }  
  Serial.write(outbyte);//this could be a weird character or might not print
  //but it's what the processing program expects
  //Here are some diagnostics to comment out:
  //Serial.print(" ");
  //Serial.println(outbyte);
  delay(200);        // delay in between reads for stability, could be 1 but I made it 200 ms
}




