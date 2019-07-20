enlistFiles=function (conn)
    	dofile("responseHeaders.lua")
        conn:send(responseHeader2("200 OK","application/json; charset=utf-8"));
        responseHeader2=nil
        conn:send("[")
        local ssid_array={}

        local li = file.list();
        for k,v in pairs(li) do
          table.insert(ssid_array,'{"file":"'..k ..'","size":"'.. tostring(v) ..'"}')
        end
        li=nil
        --print( table.concat(ssid_array,",") .. "]")
        conn:send( table.concat(ssid_array,",") .. "]")
        ssid_array=nil
end
