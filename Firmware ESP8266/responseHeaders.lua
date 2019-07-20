responseHeader = function(code, type)      
    return "HTTP/1.1 " .. code .. "\r\nConnection: close\r\nServer: nunu-Luaweb\r\nContent-Type: " .. type .. "\r\n\r\n";   
end 
responseHeader2 = function(code, type)      
    return "HTTP/1.1 " .. code .. "\r\nConnection: Keep-Alive\r\nServer: nunu-Luaweb\r\nContent-Type: " .. type .. "\r\n\r\n";   
end    
