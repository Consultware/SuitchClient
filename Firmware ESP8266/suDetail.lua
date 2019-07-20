suDetail=function(con)
--obtenemos la ip
	str=wifi.ap.getmac()
	str = str:gsub('%W','')
    str="Suitchv2"..string.sub(str,-4)
    local mf=file.open("suitchTKN.cfg", "r")
    token="NONE"
   if mf~=nil then
       token=file.readline()
       file.close()
   end 
   network="NONE"
   thisip=wifi.sta.getip()
   if thisip==nil then
    thisip="NONE"
   end
   local mf2=file.open("underLayer.cfg", "r")
	if mf2~=nil then
		network=string.gsub(file.readline(), "\n", "")
    	file.close()
    end
  size=0
  for n,s in pairs(file.list()) do 
    size=size+s 
  end
  n=nil
  s=nil
  dofile("responseHeaders.lua")
  con:send(responseHeader2("200 OK","application/json; charset=utf-8"));
	con:send('{"ip":"'..thisip..'","ssid":"'..str..'","token":"'..string.gsub(token, "\n", "")..'","network":"'..network..'","ram":"'..node.heap()..'","size":"'..size..'","state":"'..gpio.read(4)..'"}')
	str=nil
  thisip=nil
	token=nil
	network=nil
  responseHeader=nil
  responseHeader2=nil
  mf=nil
  mf2=nil
  size=0
end
