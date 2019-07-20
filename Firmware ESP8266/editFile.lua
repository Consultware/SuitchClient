modifyFile=function (request,conn)
    local _k, _l, method, url, vars = string.find(request, "([A-Z]+) /([^?]*)%??(.*) HTTP")
    local t = {}
     for k, v in string.gmatch(vars, "(%w+)=(%w+)") do
       t[k] = v
     end
     _k=nil
     _l=nil
     method=nil
     vars=nil
    local rnrn=1
	local _,_,DataToG, payload = string.find(request, "Content%-Length: (%d+)(.+)")
	if DataToG~=nil then
        DataToG = tonumber(DataToG)
        print("datatoGet:"..DataToG)
        rnrn=1
    else
        print("bad length")
    end

    local payloadlen = string.len(payload)
    local mark = "\r\n\r\n"
    local i
    for i=1, payloadlen do                
        if string.byte(mark, rnrn) == string.byte(payload, i) then
            rnrn=rnrn+1
            if rnrn==5 then 
                payload = string.sub(payload, i+1,payloadlen)
                file.remove(t["fileName"]..".lua") 
                file.open(t["fileName"]..".lua", "w+")
                file.write(payload)
                file.close() 
                payload=nil
                break
            end
        else
            rnrn=1
        end
    end 
    t=nil
    dofile("responseHeaders.lua")
    conn:send(responseHeader2("200 OK","application/json; charset=utf-8"));
    responseHeader2=nil
    responseHeader=nil
end
