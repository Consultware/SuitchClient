/*
  Copyright 2014 Consultware
  andres.santos@consultware.mx

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.


This is a file using module Rovin Wifly, you can buy this from
https://www.sparkfun.com/products/9954

In this particular example, a command from the server is sent to the arduino
and it reacts to these instructions
 */
int reset=0;
int waitingCharacter=0;
String incomingString;
char incomingCharacter;
signed long timeout=0;
signed long nextPing=0;

void startConnection(){
  incomingString=String("X");
  waitingCharacter=0;
  reset=1;
  digitalWrite(12,LOW);
  delay(2000);
  digitalWrite(12,HIGH);
  digitalWrite(13,LOW);

  //Serial.println("GO");
}
// the setup routine runs once when you press reset:
void setup() {
  // initialize serial communication at 9600 bits per second:
  
  // make the pushbutton's pin an input:
  pinMode(9, OUTPUT);
  pinMode(12, OUTPUT);
  pinMode(13, OUTPUT);
  digitalWrite(13,LOW);
  digitalWrite(9,LOW);
  delay(200);
  digitalWrite(13,HIGH);
  digitalWrite(9,HIGH);
  delay(200);
  digitalWrite(13,LOW);
  digitalWrite(9,LOW);
  delay(200);
  digitalWrite(13,HIGH);
  digitalWrite(9,HIGH);
  delay(200);
  digitalWrite(13,LOW);
  digitalWrite(9,LOW);
  
  Serial.begin(9600);
  nextPing = millis() + 20000;
  timeout = millis() + 30000;
  startConnection();
    
}

// the loop routine runs over and over again forever:
void loop() {
  // read the input pin:
  if(Serial.available()){
  incomingCharacter=Serial.read();
  if (incomingCharacter == '\n' || incomingCharacter== '\r') {
   //testear las entradas
    if(reset==1){
     //como lo reseteamos esperamos que la palabra sea READY
     if(incomingString=="X*READY*"){
       //enviamos el comando de conexion
       incomingString="X";
       Serial.print("$$$");
     } else if(incomingString=="XCMD") {
       incomingString="X";
       Serial.println("join Unknown");       
     } else if(incomingString=="XListen on 2000"){
       //ya nos conectamos salir del modo reset
       incomingString="X";
       Serial.println("open lineaccess.mx 3000");
     } else if(incomingString=="X*OPEN*TOKEN?"){
       incomingString="X";
       reset=0;
       //this is the department vacuum
       Serial.println("YOUR_TOKEN/YOUR_SECRET_TOKEN");
     } else {
       incomingString="X";
    }
    } else {
     //una vez conectados enviamos token y esperamos respuesta
     if(incomingString=="XWLCME"){
      digitalWrite(13,HIGH);
      //ingresamos correctamente, enviar un tweet
       //Serial.println("twitter hello world from arduino wifi");
      // waitingCharacter=1;
      
      incomingString="X";
     } else if(incomingString=="XOK"){
       //reseteamos contadores
       waitingCharacter=0;
       incomingString="X";
       
     } else if(incomingString=="XPING"){
       incomingString="X";
       waitingCharacter=0;
     } else if(incomingString=="XON" || incomingString=="Xon"){
       incomingString="X";
       waitingCharacter=0;
       digitalWrite(9,HIGH);
     } else if(incomingString=="XOFF" || incomingString=="Xoff"){
       incomingString="X";
       waitingCharacter=0;
       digitalWrite(9,LOW);
     }
    }
  } else if(incomingCharacter!=0xFF){
   //pegar los caracteres
   incomingString=incomingString+incomingCharacter;
   //Serial.println(incomingString);
  }
 
  }
   delay(1);        // delay in between reads for stability
   if(reset==1){
      if (((signed long)(millis() - nextPing)) > 0) {
        nextPing = millis() + 40000;
        //ayuda a saber si aun no se conecta, en tal caso reconectar
        startConnection();
      }
  }
  if(reset==0 && waitingCharacter==1){
    if (((signed long)(millis() - timeout)) > 0) {
        nextPing = millis() + 40000;
        timeout = millis() + 50000;
        //ayuda a saber si aun no se conecta, en tal caso reconectar
        startConnection();
     }
  } else if(reset==0 && waitingCharacter==0){
    if (((signed long)(millis() - nextPing)) > 0) {
       nextPing = millis() + 40000;
        timeout = millis() + 50000;
        //ayuda a saber si aun no se conecta, en tal caso reconectar
        waitingCharacter=1;
        Serial.println("ping");
     }
  }
     
}



