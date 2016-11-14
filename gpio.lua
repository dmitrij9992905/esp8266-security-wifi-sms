button1 = 3
button2 = 4
button3 = 7
stateled = 8
press = 0
led = 0
lightstate = 0
secswitch = 0
pos = 1;
code = {0,0,0,0,0,0}
enter = {0,0,0,0,0,0}
press = 0
enter_delay = 0

gpio.mode(button1,gpio.INPUT,gpio.PULLUP)
gpio.mode(button2,gpio.INPUT,gpio.PULLUP)
gpio.mode(button3,gpio.INPUT,gpio.PULLUP)
gpio.mode(stateled, gpio.OUTPUT)
gpio.write(stateled, gpio.LOW)

 
file.open("code.txt","r")  
buf_file = file.read(8)
for pos = 1,6,1 do 
   code[pos] = string.sub(buf_file,pos,pos) 
end

tmr.register(6,10,1, function()
     
    if (gpio.read(button1) == 0) then 
        if (press == 0) then 
            press = 1;
            print("1 pressed\n");  
            enter[pos] = "1";
            pos = pos+1
            led = 2
            enter_delay = 0
            --tmr.start(5); 
        end
    elseif (gpio.read(button2) == 0) then 
        if (press == 0) then 
            press = 1;
            print("2 pressed\n");  
            enter[pos] = "2";
            pos = pos+1
            led = 2
            enter_delay = 0
        end
    elseif (gpio.read(button3) == 0) then 
        if (press == 0) then 
            press = 1;
            print("3 pressed\n");  
            enter[pos] = "3";
            pos = pos+1
            led = 2
            enter_delay = 0
        end
    else
        press = 0
        tmr.start(2)
        enter_delay=enter_delay+1
        if (enter_delay > 1000) then
            print("Time Out\n")
            led = 5
            enter_delay = 0
            tmr.start(0)
            tmr.stop(6)
        end
        if (pos > 6) then
            --pos = 1
            secswitch = 1
            for pos=1,6,1 do 
                if (enter[pos] == code[pos]) then
                    secswitch = 1
                else 
                    secswitch = 0
                    print("Incorrect PIN!!!\n")
                    led = 3
                    enter_delay = 0
                    pos = 1
                    tmr.start(0)
                    tmr.stop(6)
                    break
                end
            end
            
            if (secswitch == 1) then 
                pos = 1
                security = security+1
                if (security > 1) then security = 0 end
                if (security == 1) then
                    just = 1
                    justTimer = 2000
                    print("Security ON\n")
                    led = 4
                    noloop = 0
                else 
                    print("Security OFF\n")
                    led = 5 
                end
                print("PIN entered")
                enter_delay = 0
                
                tmr.start(0)
                tmr.stop(6) 
            end
        end
    end
end)

tmr.register(5,1000,tmr.ALARM_SEMI,function()
   if (gpio.read(button1) == 0) then 
        print("1 long pressed\n");
        led = 2;
        lightstate = gpio.read(light);
        lightstate = lightstate+1;
        if (lightstate>1) then lightstate = 0; end
        if (lightstate == 1) then gpio.write(light, gpio.HIGH);
        else gpio.write(light, gpio.LOW); end
   elseif (gpio.read(button2) == 0) then 
        print("2 long pressed\n");
        pos = 1;
        print("Enter PIN on buttons\n")
        led = 5
        tmr.stop(3)
        tmr.stop(2)
        tmr.start(6)
        tmr.stop(0)
        --press=0
   elseif (gpio.read(button3) == 0) then print("3 long pressed\n");
   end
   tmr.stop(5)
end)



tmr.alarm(0,10,1,function() 
    if (gpio.read(button1) == 0) then 
        if (press == 0) then 
            press = 1;
            print("1 pressed\n");    
            tmr.start(5); 
        end
    elseif (gpio.read(button2) == 0) then 
        if (press == 0) then 
            press = 1;
            print("2 pressed\n");    
            tmr.start(5); 
        end
   elseif (gpio.read(button3) == 0) then 
        if (press == 0) then 
            press = 1;
            print("3 pressed\n");    
            tmr.start(5); 
        end
    else
        tmr.stop(5)
        press = 0 
    end
end)

count = 0

tmr.alarm(4,120,1,function() 
    if (led == 1) then
        gpio.write(stateled, gpio.HIGH)
    elseif (led == 2) then
        
            gpio.write(stateled, gpio.HIGH)
            count = count+1
            if (count > 1) then
                gpio.write(stateled, gpio.LOW)
                led = 0
                count = 0
            end
        
    elseif (led == 3) then
        
            gpio.write(stateled, gpio.HIGH)
            tmr.delay(50)
            gpio.write(stateled, gpio.LOW)
            tmr.delay(50) 
            count = count+1
            if (count>5) then 
                gpio.write(stateled, gpio.LOW)
                led = 0
                count = 0
            end
        
    elseif (led == 4) then
        
            gpio.write(stateled, gpio.HIGH)
            count = count+1
            if (count > 8) then
                gpio.write(stateled, gpio.LOW)
                led = 0
                count = 0
            end
    elseif (led == 5) then
        
            gpio.write(stateled, gpio.HIGH)
            tmr.delay(50)
            gpio.write(stateled, gpio.LOW)
            tmr.delay(50) 
            count = count+1
            if (count>2) then 
                gpio.write(stateled, gpio.LOW)
                led = 0
                count = 0
            end
        
    else
        
        gpio.write(stateled, gpio.LOW)
    end
end)


