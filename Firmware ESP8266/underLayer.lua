start_init = function()   
    wifi.setmode(wifi.STATIONAP);
    cfg={}
    str=wifi.ap.getmac()
    gpio.mode(1, gpio.OUTPUT)
    str = str:gsub('%W','')
    cfg.ssid="Suitchv3"..string.sub(str,-4)
    wifi.ap.config(cfg)
     --print("get config")
    local mf=file.open("underLayer.cfg", "r")
    if mf~=nil then
        local ms=string.gsub(file.readline(), "\n", "")
        local mp=string.gsub(file.readline(), "\n", "")
        file.close()
        print(ms)
        print(mp)
        station_cfg={}
        station_cfg.ssid=ms
        station_cfg.pwd=mp
        station_cfg.save=false
        wifi.sta.config(station_cfg); 
        station_cfg=nil 
        wifi.setmode(wifi.STATION)
    else
        --station_cfg={}
        --station_cfg.ssid="SuitchV3"
        --station_cfg.pwd="password"
        --station_cfg.save=false
        --wifi.sta.config(station_cfg)
        --wifi.setmode(wifi.STATIONAP);
        --cfg={}
        --str=wifi.ap.getmac()
        --gpio.mode(1, gpio.OUTPUT)
        --str = str:gsub('%W','')
        --cfg.ssid="Suitchv3"..string.sub(str,-4)
        --wifi.ap.config(cfg)
        --cfg=nil
        --str=nil
     end
     cfg=nil
     str=nil
  --print("post config")
    mf=nil
end   
