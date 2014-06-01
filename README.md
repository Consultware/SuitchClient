Suitch Internet of things Cloud Server
============
The suitch server technically known as arduinoNetwork or a-Network offers the following features to your software/hardware projects.

 - Voice recognition by landline phone
 - Voice recognition by cellphone
 - Voice recognition by calling with Skype
 - Text regnition by sending IM with facebook
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
IP: 209.177.156.249
PORT: 3000
Try this on terminal OSX, Linux:

    >nc 209.177.156.249 3000

Windows:

    >telnet 209.177.156.249 3000

When succesfully connected the server will respond you with:

    >TOKEN?
Just type the token and your token secret of your registered device like separated by a forward slash:

    12732e1b/YOUR_SECRET_TOKEN
if the combination is correct it will respond with:

    >WLCME
if the combination is incorrect it will only disconnect itself as a wrong response.