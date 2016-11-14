security = 0;
request = ""
pwr = 0;
light = 1

if (connect == 1) then ip = "192.168.0.100"
else ip = "192.168.1.100" end

srv=net.createServer(net.TCP)
srv:listen(80,function(conn)
    conn:on("receive", function(client,request)
        local buf = "";
        local _, _, method, path, vars = string.find(request, "([A-Z]+) (.+)?(.+) HTTP");
        if(method == nil)then
            _, _, method, path = string.find(request, "([A-Z]+) (.+) HTTP");
        end
        local _GET = {}
        if (vars ~= nil)then
            for k, v in string.gmatch(vars, "(%w+)=(%w+)&*") do
                _GET[k] = v
            end
        end

        
        
        buf = buf..''
        buf = buf..''
        buf = buf..'<p> ESP8266 Web Server</p>';
        buf = buf..'<p>STA IP = '..getip.."</p>";
        buf = buf.."<p>STA SSID = "..sta_ssid.."</p>";
        buf = buf.."<p>STA Password = "..sta_pass.."</p>";
        buf = buf..'<a href="?light=1"><button>Light ON</button></a><br/>';
        buf = buf..'<a href="?light=0"><button>Light OFF</button></a>';
        if (gpio.read(1) == 1) then
            buf = buf..'<p>Light ON</p>';
        else
            buf = buf..'<p>Light OFF</p>';
        end
        if (security == 1) then
            buf = buf..'<p>Security ON</p>';
        else
            buf = buf..'<p>Security OFF</p>';
        end 
        if (pwr == 1) then
            buf = buf..'<p>External power is missing</p>';
        else
            buf = buf..'<p>External power is working</p>';
        end 
        buf = buf.."<p>Change AP</p>";
        buf = buf..'<form method="get"><input type="text" name="ssid"/><br/><input type="password" name="pass"/><br/><input type="submit"/></form>';
        
        local _on,_off = "",""
        --if(_GET.pin == "toggle1")then
        --print(_GET.ssid);
        --print(_GET.pass);   
        --elseif(_GET.pin == "toggle2")then
        
       -- end
        
        if (_GET.ssid ~= nil) then 
            change_sta_ssid(_GET.ssid)
            change_sta_pass(_GET.pass) 
        end  
        if (_GET.sec ~=nil) then 
            if (_GET.sec == "1") then 
                security = 1 
                noloop = 0
            else 
                security = 0
                noloop = 0
            end
        end
        if (_GET.light ~=nil) then 
            if (_GET.light == "1") then gpio.write(light,gpio.HIGH) 
            else gpio.write(light,gpio.LOW) end
        end
        if (_GET.from ~=nil) then 
            print(_GET.from);
            print(_GET.body);
            if (_GET.body == "STATE") then
                print("Fetch state") 
                request = "http://";
                request = request..ip;
                request = request..":8766/send.html?smsto=dmitrij-96%40mail.ru";
                if (security == 1) then
                    request = request..'&smsbody=Security+ON';
                else
                    request = request..'&smsbody=Security+OFF';
                    security = 0
                end
                request = request..'&smstype=email';
                print(request)
                http.get(request, nil, function(code, data)     
                    if (code < 0) then       
                    print("HTTP request failed")     
                    else       
                    print(code, data)     
                    end   
                end)
                request = "http://";
                request = request..ip;
                request = request..":8766/send.html?";
                request = request..'smsto='.._GET.from;
                if (security == 1) then
                    request = request..'&smsbody=Security+ON';
                else
                    request = request..'&smsbody=Security+OFF';
                end 
                request = request..'&smstype=sms';
                print(request)
                http.get(request, nil, function(code, data)     
                    if (code < 0) then       
                    print("HTTP request failed")     
                    else       
                    print(code, data)     
                    end   
                end)
                
            end 
            if (_GET.body == "SECON") then 
                request = "http://";
                request = request..ip;
                request = request..":8766/send.html?";
                request = request..'smsto='.._GET.from;
                if (security == 1) then
                    request = request..'&smsbody=Security+ON+Already';
                else
                    request = request..'&smsbody=Security+ENABLED';
                    security = 1
                    noloop = 0
                end 
                request = request..'&smstype=sms';
                http.get(request, nil, function(code, data)     
                    if (code < 0) then       
                    print("HTTP request failed")     
                    else       
                    print(code, data)     
                    end   
                end)
                request = "http://";
                request = request..ip;
                request = request..":8766/send.html?smsto=dmitrij-96@mail.ru";
                
                request = request..'&smsbody=Security+ENABLED';
                  
                request = request..'&smstype=email';
                http.get(request, nil, function(code, data)     
                    if (code < 0) then       
                    print("HTTP request failed")     
                    else       
                    print(code, data)     
                    end   
                end)
            end
            if (_GET.body == "LIGHTON") then
                request = "http://";
                request = request..ip; 
                request = request..":8766/send.html?";
                request = request..'smsto='.._GET.from;
                if (gpio.read(1) == 1) then
                    request = request..'&smsbody=Light+ON+Already';
                else
                    request = request..'&smsbody=Light+ENABLED';
                    gpio.write(1, gpio.HIGH);
                end 
                request = request..'&smstype=sms';
                http.get(request, nil, function(code, data)     
                    if (code < 0) then       
                    print("HTTP request failed")     
                    else       
                    print(code, data)     
                    end   
                end)
                request = "http://";
                request = request..ip;
                request = request..":8766/send.html?smsto=dmitrij-96@mail.ru";
                request = request..'&smsbody=Light+ENABLED';
                request = request..'&smstype=email';
                http.get(request, nil, function(code, data)     
                    if (code < 0) then       
                    print("HTTP request failed")     
                    else       
                    print(code, data)     
                    end   
                end)
            end
            if (_GET.body == "SECOFF") then 
                request = "http://";
                request = request..ip;
                request = request..":8766/send.html?";
                request = request..'smsto='.._GET.from;
                if (security == 0) then
                    request = request..'&smsbody=Security+OFF+Already';
                else
                    request = request..'&smsbody=Security+DISABLED';
                    security = 0
                    noloop = 0
                end 
                request = request..'&smstype=sms';
                http.get(request, nil, function(code, data)     
                    if (code < 0) then       
                    print("HTTP request failed")     
                    else       
                    print(code, data)     
                    end   
                end)
                request = "http://";
                request = request..ip;
                request = request..":8766/send.html?smsto=dmitrij-96@mail.ru";
                
                request = request..'&smsbody=Security+DISABLED';
                   
                request = request..'&smstype=email';
                http.get(request, nil, function(code, data)     
                    if (code < 0) then       
                    print("HTTP request failed")     
                    else       
                    print(code, data)     
                    end   
                end)
            end
            if (_GET.body == "LIGHTOFF") then 
                request = "http://";
                request = request..ip;
                request = request..":8766/send.html?";
                request = request..'smsto='.._GET.from;
                if (gpio.read(1)==0) then
                    request = request..'&smsbody=Light+OFF+Already';
                else
                    request = request..'&smsbody=Light+DISABLED';
                    gpio.write(1, gpio.LOW);
                end 
                request = request..'&smstype=sms';
                http.get(request, nil, function(code, data)     
                    if (code < 0) then       
                    print("HTTP request failed")     
                    else       
                    print(code, data)     
                    end   
                end)
                request = "http://";
                request = request..ip;
                request = request..":8766/send.html?smsto=dmitrij-96@mail.ru";
            
                --request = request..'&smsbody=Security+OFF+Already';
                request = request..'&smsbody=Light+DISABLED';
                --gpio.write(11, gpio.HIGH);
                request = request..'&smstype=email';
                http.get(request, nil, function(code, data)     
                    if (code < 0) then       
                    print("HTTP request failed")     
                    else       
                    print(code, data)     
                    end   
                end)
            end
            if (_GET.body == "LIGHT") then
                print("Fetch state light") 
                request = "http://";
                request = request..ip;
                request = request..":8766/send.html?smsto=dmitrij-96%40mail.ru";
                if (gpio.read(1) == 1) then
                    request = request..'&smsbody=Light+ON';
                else
                    request = request..'&smsbody=Light+OFF';
                    security = 0
                end
                request = request..'&smstype=email';
                print(request)
                http.get(request, nil, function(code, data)     
                    if (code < 0) then       
                    print("HTTP request failed")     
                    else       
                    print(code, data)     
                    end   
                end)
                request = "http://";
                request = request..ip;
                request = request..":8766/send.html?";
                request = request..'smsto='.._GET.from;
                if (gpio.read(1) == 1) then
                    request = request..'&smsbody=Light+ON';
                else
                    request = request..'&smsbody=Light+OFF';
                end 
                request = request..'&smstype=sms';
                print(request)
                http.get(request, nil, function(code, data)     
                    if (code < 0) then       
                    print("HTTP request failed")     
                    else       
                    print(code, data)     
                    end   
                end) 
            end
        end
        client:send(buf);
        client:close();
        collectgarbage(); 
        
    end)
end)

function change_sta_ssid(new_ssid) 
    _,start=string.find(buf_file, 'sta_ssid=')
    en,_=string.find(buf_file, ';', start)
    start_str = string.sub(buf_file,1,start)
    end_str = string.sub(buf_file, en)
    buf_file = start_str..new_ssid..end_str
    file.remove("settings.txt")
    file.open("settings.txt","w")
    file.write(buf_file)
    file.close()
    print(new_ssid) 
end

function change_sta_pass(new_pass) 
    _,start=string.find(buf_file, 'sta_pass=')
    en,_=string.find(buf_file, ';', start)
    start_str = string.sub(buf_file,1,start)
    end_str = string.sub(buf_file, en)
    buf_file = start_str..new_pass..end_str
    file.remove("settings.txt")
    file.open("settings.txt","w")
    file.write(buf_file)
    file.close()
    print(new_pass) 
end

