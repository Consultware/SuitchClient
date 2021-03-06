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


This is a file using the arduino ethernet, you can buy this from
http://arduino.cc/en/Main/ArduinoBoardEthernet

In this particular example we use the arduino ethernet, so you simple upload the 
sketch and you are ready to go, a command from the server is sent to the arduino
and it reacts to these instructions

There are several advantages in using this module, you can control your lights from this
same chip that connects to the Suitch a-Network Server.
 */

#include <SPI.h>
#include <Ethernet.h>
#include <EthernetUdp.h>
// Enter a MAC address and IP address for your controller below.
// The IP address will be dependent on your local network:
byte mac[] = { 0x35, 0xF5, 0x7A, 0x82, 0x2A, 0x7C };
IPAddress ip(10,0,1,50);

byte packetBuffer[3];
int reset=0;
int waitingCharacter=0;
String incomingString;
char incomingCharacter;
int contadorA=0;
int contadorB=0;
int contadorC=0;
unsigned int localPort = 8888;
EthernetUDP Udp;

// Enter the IP address of the server you're connecting to in this case the
//arduino network a-Network
IPAddress server(209,177,156,249); 

// Initialize the Ethernet client library
// with the IP address and port of the server 
EthernetClient client;

void startConnection(){
  Serial.println("connecting to lineaccess");
  Udp.begin(localPort);
  // if you get a connection, report back via serial:
  if (client.connect(server, 3000)) {
    Serial.println("connected");
  } 
  else {
    // if you didn't get a connection to the server:
    Serial.println("connection failed");
  }
}
void setup() {
  // start the Ethernet connection:
  Ethernet.begin(mac, ip);
  incomingString=String("X");
 // Open serial communications and wait for port to open:
  Serial.begin(9600);
   while (!Serial) {
    ; // wait for serial port to connect. Needed for Leonardo only
  }
  
  // give the Ethernet shield a second to initialize:
  delay(1000);
  startConnection();
}

void loop()
{
  // if there are incoming bytes available 
  // from the server, read them and print them:
  if (client.available()) {
    incomingCharacter=client.read();
    Serial.print(incomingCharacter);
    if (incomingCharacter == '\n' || incomingCharacter== '\r') {
      if(incomingString=="XTOKEN?"){
       client.println("YOUR_TOKEN/YOUR_SECRET_TOKEN");
       incomingString="X";
      } else if(incomingString=="XWLCME"){
        //quiere decir que entramos bien
        Serial.println("Connected to a-Network");
        reset=1;
        incomingString="X";
        /* IN CASE YOU NEED MORE CONDITIONS JUST ADD THEM JUST LIKE THE -PING- MESSAGES*/
      } else if(incomingString=="XPING"){
       incomingString="X"; 
      } else if(incomingString=="XPONG"){
       incomingString="X";
      }else {
        incomingString="X";
      }
    } else {
     incomingString=incomingString+incomingCharacter; 
    }
  }
  if(reset==1){
   
  contadorA=contadorA+1;
  if(contadorC==200){
    client.println("ping");
    contadorC=0;
  }
  if(contadorA>=31000){
   contadorA=0;
   contadorC=contadorC+1;
   Serial.println(contadorC);
   contadorB=contadorB+1; 
   if(contadorB>=31000){
    contadorB=0; 
   }
  }
  }
  // as long as there are bytes in the serial queue,
  // read them and send them out the socket if it's open:
  while (Serial.available() > 0) {
    char inChar = Serial.read();
    if (client.connected()) {
      client.print(inChar); 
    }
  }

  // if the server's disconnected, stop the client:
  if (!client.connected()) {
    Serial.println();
    Serial.println("disconnecting.");
    client.stop();
    reset=0;
    startConnection();
    // do nothing:
  }
}




