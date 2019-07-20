local sk=net.createConnection(net.TCP, 0)
gpio.mode(4, gpio.OUTPUT)
gpio.write(4, gpio.LOW)
gpio.mode(1, gpio.OUTPUT)
gpio.write(1, gpio.LOW)
gpio.mode(12, gpio.OUTPUT)
gpio.write(12, gpio.LOW)
local xx = 0
local isConnected = 0
local savingFile = nil
sk:on("receive", 
    function(sck, c) 
        print(c)
        if savingFile ~=nil then
            if string.find(c,"<<<END", 1, true)~=nil then
                --cerrar archivo
                savingFile = nil
                print("closing file")
            else
                fileAccess = "a+"
                if file.exists(savingFile) == false then
                    fileAccess = "w"
                end
                if file.open(savingFile, fileAccess) then
                  -- write 'foo bar' to the end of the file
                  file.write(c)
                  file.close()
                end
                fileAccess = nil
            end
        elseif string.match(c,"TOKEN_ERROR") or string.match(c,"TOKEN?") then
            --print("send TOKEN")
           local mf=file.open("suitchTKN.cfg", "r")
           if mf~=nil then
               sk:send(file.readline())
               file.close()
           else 
            xx=1
            sk:send("Lorem ipsum dolor sit amet\n")
           end
           mf = nil
        elseif string.match(c,"fileBrowser") then
            local files_array={}
            l = file.list();
            sk:send("fileBrowser=[")
            for k,v in pairs(l) do
              table.insert(files_array,'{"file":"'..k ..'","size":"'.. tostring(v) ..'"}')
              print("name:"..k..", size:"..v)
            end
            li=nil
            sk:send(table.concat(files_array,",") .. "]\n")
            files_array = nil
        elseif string.find(c, 'openFile', 1, true)~=nil then
             print("requesting file...")
             local DataToGet = 0
             
             command, cloud_file = c:match("([^,]+) ([^,]+)")
             print(string.gsub(cloud_file, "\n", "", 2))
             local fileSize = file.stat(string.gsub(cloud_file, "\n", "", 2)).size
             if file.open(string.gsub(cloud_file, "\n", "", 2), "r") then            
                
                while DataToGet<fileSize do
                    file.seek("set", DataToGet)
                    local line=file.read(512)
                    
                    if line then
                        if DataToGet == 0 then
                            sk:send("openFile=<<<BEGIN");
                        end
                        DataToGet = DataToGet + 512
                        print("datatoGet" .. DataToGet)
                        sk:send(line)
                        
                    else
                        break;
                    end
                    line = nil
                end
                file.close()
            end 
            fileSize = nil
            DataToGet = nil
            command = nil
            cloud_file = nil
            sk:send("<<<END\n")
        elseif string.find(c,"saveFile", 1, true)~=nil then
            command, file_name = c:match("([^,]+) ([^,]+)")
            savingFile = string.gsub(file_name, "\n", "", 2)
            command = nil
            file_name = nil
            file.remove(savingFile)
        elseif string.match(c,"on") then
            gpio.write(4, gpio.HIGH)
            gpio.write(1, gpio.HIGH)
            gpio.write(12, gpio.HIGH)
        elseif string.match(c,"off") then
            gpio.write(4, gpio.LOW)
            gpio.write(1, gpio.LOW)
            gpio.write(12, gpio.LOW)
        end
        if xx==1 and string.match(c,"TOKEN_ERROR")==nil and string.match(c,"TOKEN?")==nil then
               xx=0
            file.open("suitchTKN.cfg", "w+")
            file.writeline(c)
            file.close()
        end
        end )
sk:on("disconnection",
     function(sck, c)
     print("die")
     isConnected = 0
     --node.restart()
     --sk=nil
     --sk=net.createConnection(net.TCP, 0)
     --sk:connect(3000,"62.210.71.15")
     end)
sk:on("connection",
     function(sck, c)
     print("suitch.network attached")
     isConnected = 1
     end) 
--sk:connect(3000,"62.210.71.15")
sk:connect(3000,"72.14.182.147")









suitchNetworkPingAlive = tmr.create()
suitchNetworkPingAlive:register(9000, tmr.ALARM_AUTO, function() 
        if sk==nil or isConnected == 0 then
          print("no suitch")
          --sk=net.createConnection(net.TCP, 0)
          if wifi.sta.getip() then
            sk:connect(3000,"72.14.182.147")
          end
        else
          sk:send("ping\n")
        end
        --print("ping")
end)
suitchNetworkPingAlive:start()
sk:send("ping\n")
gpio.mode(2,gpio.INT)
pulse1 = 0
du = 0

function pin1cb(level)
print("btn")
     if level==0 then
          pulse1=tmr.now()
     end
     if level==1 then
          du=tmr.now()-pulse1
          print(du)
          print("Calculating reset state")
     end
     if du>25358389 then
     --27 segundos
          print("restore newtwork")
          file.remove("underLayer.cfg")
          --wifi.sta.config("carwifi","carwifi")
     end



end

gpio.trig(2, "both",pin1cb)
--uart.setup(0,9600,8,0,1,0)
--uart.on("data", "\n", 
--      function(data)
        --print("receive from uart:", data)
--        sk:send(data)
--    end, 0)
