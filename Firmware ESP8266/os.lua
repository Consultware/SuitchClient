dofile("underLayer.lua") 
httpserver = function ()      
start_init();
start_init=nil   
srv=net.createServer(net.TCP)       
srv:listen(80,function(conn)   
local DataToGet = 0
local ajax = 0
local currentFileName = nil

    conn:on("receive",function(conn,request)
         _, _, method, url, vars = string.find(request, "([A-Z]+) /([^?]*)%??(.*) HTTP")
        print("--->") 
       print(method, url, vars) 
       print("<---") 
       -- print("request:"..request);      
        if method=="POST" then
            --buscar los metodos
            if url=="scan.suit" then
                dofile("scanNetwork.lua")
                sendJson(conn)
                sendJson=nil
                ajax=1
            elseif url=="browseFiles.suit" then
                dofile("listFiles.lua")
                enlistFiles(conn)
                enlistFiles=nil
                ajax=1
            elseif url=="save.suit" then
                dofile("editFile.lua")
                modifyFile(request,conn)
                modifyFile=nil
                ajax=1
            elseif url=="connect.suit" then
                dofile("unLayFact.lua")
                createConfig(request)
                createConfig=nil
                ajax=1
            elseif url=="details.suit" then
                dofile("suDetail.lua")
                suDetail(conn)
                suDetail=nil
                ajax=1
            elseif url=="servo.suit" then
                --pwm.setup(4, 50, 130)
                --pwm.start(4)
                --print("GRAD:"..string.sub (vars, 6))
                pwm.setup(4, 50, string.sub (vars, 6))
                pwm.start(4)
                ajax=1
            elseif url=="turn.suit" then
                if vars=="turn=true" then
                    gpio.mode(12, gpio.OUTPUT)
                    gpio.write(12, gpio.HIGH)
                    print("LED IS ON")
                else
                    gpio.mode(12, gpio.OUTPUT)
                    gpio.write(12, gpio.LOW)
                    print("LED IS OFF")
                end
                dofile("responseHeaders.lua")
                conn:send(responseHeader("200 OK","text/html"));  
                responseHeader=nil
                responseHeader2=nil
                method=nil
                url=nil
                vars=nil
                ajax=1
            end
            return
        end
        if url~="" then
            currentFileName=url    
        else 
            currentFileName="welcome.html"
        end
        local lm = file.list();
        isFileFound=0
        for k,v in pairs(lm) do
          if k==currentFileName then
            isFileFound=1
            dofile("responseHeaders.lua")
            conn:send(responseHeader("200 OK","text/html"));  
            responseHeader=nil
            responseHeader2=nil
            --print("ARCHIVO ENCONTRADO")
          end
        end
        lm=nil
        
        if isFileFound==0 then   
            --print("ARCHIVO NO ENCONTRADO")         
            conn:send("HTTP/1.1 404 file not found")
            return
        end          
            end)         
conn:on("sent",function(conn)  
if DataToGet>=0 and ajax==0 and file~=nil then
        if file.open(currentFileName, "r") then            
            file.seek("set", DataToGet)
            local line=file.read(512)
            file.close()
            if line then
                conn:send(line)
                DataToGet = DataToGet + 512    

                if (string.len(line)==512) then
                    return
                end
            end
        end        
    end         
    conn:close();           
    conn = nil;              
    end)      
end)  
end    
httpserver()
dofile("autoConnect.lua")
