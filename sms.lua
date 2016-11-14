

gpio.mode(light,gpio.OUTPUT)
gpio.write(light,gpio.LOW)
gpio.mode(5, gpio.INPUT, gpio.PULLUP)
gpio.mode(2, gpio.INPUT)

flag = 0;
blink = 0;
noloop = 0;
just = 0;
justTimer=0;

number = {"89608180261","89171494347","89270108986"};
text = {"Invasion+detected!","Power+is+missing","Power+is+restored"};



--local function sendSms1(number, text)
--local request = ""
--request = "http://192.168.0.100:8766/?";
--request = request..'number='..number;
--request = request..'&message='..text;
--    http.get(request, nil, function(code, data)     
--        if (code < 0) then       
--        print("HTTP request failed")     
--        else       
--        print(code, data)     
--        end   
--    end)
--end

inc = 1;
attempt = 0;
tmr.register(3,15000,tmr.ALARM_SEMI,function()
   attempt=attempt+1;
   print(text[1])
   for inc=1,3,1 do 
        print(inc)
        emailRequest(1);
        tmr.delay(500000);
        sendSms(1, inc); 
   end
   if (attempt > 4) then
       flag = 1;
       
       tmr.stop(3)
   end
   
end)

tmr.alarm(2,10, 1, function () 
    if (security == 1 and just == 1) then
        justTimer = justTimer - 1;
        if (justTimer <= 0) then 
            just = 0
            print("Time out")
        end
    else
        if (security == 1) then 
            blink = blink+1
            if (blink > 400) then
                led = 2
                blink = 0
            end
        end
        if (gpio.read(5) == 1 and security == 1 and just == 0) then noloop = 1 end
        if (noloop == 1 and security == 1 and just == 0) then
            if (flag == 0) then
                print("Invasion")
            --request = "http://192.168.0.100:8766/send.html?smsto=89608180261&smsbody=Invasion+detected!&smstype=sms"
                tmr.start(3)
                flag = 1; 
            end  
        else 
            flag = 0
            attempt = 0
            tmr.stop(3)
        end 
        if (gpio.read(2) == 0) then
            if (pwr == 0) then
            --request = "http://192.168.0.100:8766/send.html?smsto=89608180261&smsbody=Invasion+detected!&smstype=sms"
                --tmr.start(3)
                print(text[2])
                for inc=1,3,1 do 
                    print(inc)
                    emailRequest(2);
                    tmr.delay(500000);
                    sendSms(2, inc); 
                end
                pwr = 1; 
            end  
        else 
            if (pwr == 1) then
                pwr = 0
                print(text[3])
                for inc=1,3,1 do 
                    print(inc)
                    emailRequest(2);
                    tmr.delay(500000);
                    sendSms(2, inc); 
                end
                --attempt = 0
                --tmr.stop(3)
            end
        end 
    end
end)

function sendSms(txt, nums) 
    tmr.wdclr();
    request = "http://";
    request = request..ip;
    request = request..":8766/send.html?";
    request = request..'smsto='..number[nums];
    request = request..'&smsbody='..text[txt];
    request = request..'&smstype=sms'
    http.get(request, nil, function(code, data)     
        if (code < 0) then       
        print("HTTP request failed")     
        else       
        print(code, data)     
        end   
    end)
    tmr.delay(500000)
    tmr.wdclr()
end



function emailRequest(txt) 
    request = "http://";
    request = request..ip;
    request = request..":8766/send.html?smsto=dmitrij-96@mail.ru&smsbody="
    request = request..text[txt]
    request = request.."&smstype=email"
    http.get(request, nil, function(code, data)     
        if (code < 0) then       
        print("HTTP request failed")     
        else       
        print(code, data)     
        end   
    end)
end
