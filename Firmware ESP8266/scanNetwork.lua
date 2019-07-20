sendJson=function(conn)
    wifi.sta.getap(function (tii)
        dofile("responseHeaders.lua")
        conn:send(responseHeader2("200 OK","application/json; charset=utf-8"));
        
        local ssid_array={}
        if tii==nil then
            table.insert(ssid_array,'{"ssid":"NONE"}')
        else
          for kii,vii in pairs(tii) do
            print("ssid" .. kii .. "-")
            table.insert(ssid_array,'{"ssid":"' .. kii .. '","security":"'.. vii..'"}')
          end
          
          
      end
      conn:send("["..table.concat(ssid_array,",") .. "]")
      ssid_array=nil
      responseHeader=nil
      responseHeader2=nil
        end)
end
