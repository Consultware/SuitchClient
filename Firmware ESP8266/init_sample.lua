--local onOff=0
--print("iniciar")
--tmr.alarm(1, 3000, 1,function()
--print("inside")
--    if onOff==0 then
--        gpio.mode(1, gpio.OUTPUT)
--        gpio.write(1, gpio.HIGH)
--        onOff=1
  --      print("encendido")
    --else
      --  gpio.mode(1, gpio.OUTPUT)
        --gpio.write(1, gpio.LOW)
        --onOff=0
        --print("apagado")
    --end
    
--end
--)
--dofile("os.lc")
function pin1cb(level)
print("btn")
     



end

gpio.trig(4, "both",pin1cb)
