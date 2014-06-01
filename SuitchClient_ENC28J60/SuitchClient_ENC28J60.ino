/*
 *
 * UIPEthernet is a TCP/IP stack that can be used with a enc28j60 based
 * Ethernet-shield.
 *
 * UIPEthernet uses the fine uIP stack by Adam Dunkels <adam@sics.se>
 *
 *      -----------------
 *
 * Copyright (C) 2013 by Norbert Truchsess <norbert.truchsess@t-online.de>
 */
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


This is a file using the ENC28J60 Chip as ethernet
The advantage of using this chip is that, it is cheaper and it contains the same
quality of connection as the Wiznet series.

There are several advantages in using this module, you can control your lights from this
same chip that connects to the Suitch a-Network Server.
 */

#include <UIPEthernet.h>

IPAddress server(209,177,156,249);
EthernetClient client;
char incomingCharacter;
String incomingString;
signed long next;
int contadorA=0;
int contadorB=0;
int contadorC=0;
int reset=0;
void startConnection(){
  incomingString="X";
  digitalWrite(9,LOW);
  delay(1000);
  digitalWrite(9,HIGH);
  delay(2000);
  uint8_t mac[6] = {0x35, 0xF5, 0x7A, 0x82, 0x2A, 0x7A};
  Ethernet.begin(mac);

  Serial.print("ME: ");
  Serial.println(Ethernet.localIP());
  Serial.print("subnetMask: ");
  Serial.println(Ethernet.subnetMask());
  Serial.print("gatewayIP: ");
  Serial.println(Ethernet.gatewayIP());
  Serial.print("dnsServerIP: ");
  Serial.println(Ethernet.dnsServerIP());
  Serial.println("connecting...");
  // if you get a connection, report back via serial:
  if (client.connect(server, 3000)) {
    Serial.println("connected");
  } 
  else {
    // if you didn't get a connection to the server:
    Serial.println("connection failed");
    incomingString="X";
  }
}

void setup() {
  pinMode(9, OUTPUT);
  Serial.begin(9600);
  incomingString=String("X");
  

  next = 0;
  delay(1000);
  startConnection();
}

void loop() {
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
        } else if(incomingString=="XPING"){
         incomingString="X";
        } else {
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
   if (!client.connected()) {
    Serial.println();
    Serial.println("disconnecting.");
    incomingString="X";
    client.stop();
    reset=0;
    startConnection();
    // do nothing:
  }
}
