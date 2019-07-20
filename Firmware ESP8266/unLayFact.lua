createConfig=function(request)
	local _k, _l, method, url, vars = string.find(request, "([A-Z]+) /([^?]*)%??(.*) HTTP")
    local t = {}
     for k, v in string.gmatch(vars, "([A-Za-z0-9]+)=([A-Za-z0-9-]+)") do
       t[k] = v
       print(k)
     end
     _k=nil
     _l=nil
     method=nil
     vars=nil
	file.remove("underLayer.cfg") 
    file.open("underLayer.cfg", "w+")
    file.writeline(t["ssid"])
    file.writeline(t["pwd"])
    file.close() 
    node.restart()
 --    t=nil

end
