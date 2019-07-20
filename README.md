Suitch Internet of things Cloud Server
============
The suitch server technically known as arduinoNetwork or a-Network offers the following features to your software/hardware projects.

 - Voice recognition by landline phone (deactivated from 2019)
 - Voice recognition by cellphone (deactivated from 2019)
 - Voice recognition by calling with Skype (deactivated from 2019)
 - Text regnition by sending IM with facebook (deactivated from 2019)
 - Access to your devices using the Suitch dashboard
 - Custom instructions for example "Turn on the kitchen light"
 - Store information, for example "value=1"
 - Publish to your facebook from hardware
 - Notify to your favourite IM (facebook, hangouts) from hardware
 - Publish to your twitter from hardware
 - IM between hardware, you can send messages in real-time to other suitch clients

 
How to connect to a-Network (arduino network or Suitch server)
--------------------------------------------------------------
The a-Network was designed with one single thing in mind, it has to be super easy to connect from any language and from any platform.

Use your favourite language and start a telnet connection with these parameters
IP: 72.14.182.147
PORT: 3000
Try this on terminal OSX, Linux:

    >nc 72.14.182.147 3000

Windows:

    >telnet 72.14.182.147 3000

When succesfully connected the server will respond you with:

    >TOKEN?
Just type the token and your token secret of your registered device like separated by a forward slash:

    12732e1b/YOUR_SECRET_TOKEN
if the combination is correct it will respond with:

    >WLCME
if the combination is incorrect it will only disconnect itself as a wrong response. From this point you have an always ON persistant connection, it is up to you to reconnect if your hardware goes offline, our Suitch hardware is specially designed to reconnect as soon as loses connection, also the arduino examples in this repository propose ways to make these reconnections.



How to publish to facebook wall
-------------------------------
As soon as you get connected to the server just push this line into the server and it will handle all the authorization required to publish. 

    fbwall hello world, how are you?
That simple! bum!

How to publish to twitter
-------------------------
As soon as you get connected to the server just push this line into the server and it will handle all the authorization required to publish. Make sure you linked your account to Suitch in the dashboard.

    twitter hello twitters!
    

How to send yourself an email
-----------------------------
There are two ways of sending emails,as soon as you get connected to the server just push this line into the server and it will handle all the authorization required to send email. Make sure you linked your google account to Suitch in the dashboard.

If you want to send yourself an email just do this

    mail hey! I am sending an email to myself
For sending emails to other address

    mail someone@domain.com hey! this email is from hardware
    

How to store values, from sensors
---------------------------------
Storing values is one of the most important things you need when developing a hardware project, and the a-Network provides you with storage for all that information into our cloud, so no worries when saving values. These values are also plotted and can be visualized from the configuration of your device in the dashboard.

    val=123
Val is the name of the command you set in your device settings in the Suitch dashboard. For example if you set up a command with the name -turnON- then the way to store values from this would be

    turnON=123

How to send messages between devices connected to the a-Network
---------------------------------------------------------------
There are lots of software packages that call this Messaging, others call this push notifications and so on. The a-Network provides all this functionality and fortunately very very simple to implement. The messaging between clients connected would allow you to create interconnected devices, for example turn on lights one after the other.

    sendto YOUR_TOKEN somethingToSend
In YOUR_TOKEN use the token of the device you want to send information and then the part of the information you want to transfer.

How to test or send a PING
--------------------------
If you want to test a ping or need to make pings to detect disconnection you can use this command once you get connected

    ping
The a-Network will respond with

    >pong
That simple!

Hardware supported
------------------
We have made available for you different Arduino Sketches using different types of hardware. Almost all the sketches can be run using Atmega8, that means the compiled code is less than  8kb so that you save space and space is very important even for wearable devices.
In general you can use any of the following hardware and all hardware created from any of them:

 - Arduino UNO
 - Arduino Leonardo
 - Arduino Yun
 - Arduino Due
 - Arduino Micro
 - Arduino Pro
 - Arduino Mega
 - Arduino nano
 - Arduino mini
 - Arduino Fio
 - LilyPad (any)
 - Raspberry PI
 - ESP8266 any
 - ESP32 any

Internet connection modules

 - Rovin Networks modules (wifly etc etc)
 - Wiznet modules (such as W5100)
 - ENC28J60
 - ESP8266
 - ESP32

Arduino in any form/shape is supported
![Arduino UNO][1]
![Raspberry][2]
In case you need a WIFI port you can use any of these options (a Rovin WiFly module, Arduino Sketch is included in this repository, the all famous ENC28J60)
![Wifly][3]
The advantage of the ENC28J60 is that is very cheap, we could successfully created a very powerful system out of $10 including this chipset and an arduino. So very convinience for price and space.
![ENC28J60][4]
The last supported hardware is the builtin WIFI of the arduino, also known as Wiznet 5100. Which might look like the following pictures
![Wiznet chipset][5]
![Wifi arduino shield][6]


  [1]: http://upload.wikimedia.org/wikipedia/commons/3/38/Arduino_Uno_-_R3.jpg
  [2]: http://piregistration.element14.com/images/sony-rasp-pi.jpg
  [3]: http://3.bp.blogspot.com/_t0_LxJZewSk/S2DIk0_9B-I/AAAAAAAAAB0/ek-cCGpsR4k/s320/wifly-gsx-wifi-breakout-board.jpg
  [4]: http://www.openhacks.com/uploadsproductos/enc28j60_ethernet_interface_module1.jpg
  [5]: http://www.libstock.com/img/projects/7522/213/1322790032_09473_01.jpg
  [6]: http://arduino.cc/en/uploads/Main/ArduinoWiFiShield_Front_450px.jpg