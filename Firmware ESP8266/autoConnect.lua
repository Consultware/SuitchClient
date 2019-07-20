mytimer = tmr.create()
resetCounter = 0
mytimer:register(3000, tmr.ALARM_AUTO, function() 
print("recovering wifi...")
resetCounter = resetCounter +1
if resetCounter > 13 and resetCounter < 15 then
    print("Entering AP mode...")
    wifi.setmode(wifi.STATIONAP)
end
if wifi.sta.getip() then
    print("found configuration")
    print(wifi.sta.getip())
    dofile("suitchsrv.lua")
    mytimer:unregister()
    resetCounter = nil
 end
end)
mytimer:start()
