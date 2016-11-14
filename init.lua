for k,v in pairs(file.list()) do l = string.format("%-15s",k) print(l.."   "..v.." bytes") end
if (file.open("settings.txt","r") == nil) then
    file.open("settings.txt","w")
    file.write("sta_ssid=tp-link;sta_pass=krb8dlld;ap_ssid=R2D2;ap_pass=89076123;port=80;")
    file.close()
end
st = 0
connect = 0
file.open("settings.txt","r")  
buf_file = file.read(100)
_,en = string.find(buf_file, ';')
_,st = string.find(buf_file, '=') 
sta_ssid = string.sub(buf_file,st+1,en-1)
_,st = string.find(buf_file, '=', en)
_,en = string.find(buf_file, ';', st)
sta_pass = string.sub(buf_file,st+1,en-1)
_,st = string.find(buf_file, '=', en)
_,en = string.find(buf_file, ';', st)
ap_ssid = string.sub(buf_file,st+1,en-1)
_,st = string.find(buf_file, '=', en)
_,en = string.find(buf_file, ';', st)
ap_pass = string.sub(buf_file,st+1,en-1)
_,st = string.find(buf_file, '=', en)
_,en = string.find(buf_file, ';', st)
port = string.sub(buf_file,st+1,en-1)
file.close()
wifi.setmode(wifi.STATIONAP)


wifi.sta.config(sta_ssid,sta_pass)
wifi.sta.connect()
wifi.sta.autoconnect(1)
i = 0
server = 0
disconnect = 0


tmr.register(1, 1000, 1, function()
     if wifi.sta.getip() == nil then
         print("Connecting...")
         i = i+1
         if (i>10) then
            tmr.stop(1)
            i = 0
            print("Failed to connect to AP!")
            --wifi.sta.disconnect()
            getip = "0.0.0.0"
            --wifi.setmode(wifi.SOFTAP)
            cfg = {}
            cfg.ssid = ap_ssid
            cfg.pwd = ap_pass
            
            ipcfg = {}
            ipcfg.ip="192.168.1.110"
            ipcfg.gateway="192.168.1.1"
            ipcfg.netmask="255.255.255.0"
            wifi.ap.setip(ipcfg)
            wifi.ap.config(cfg)
            connect = 0;
            event_connect()
            i = 0;
            if (server == 0) then
                dofile("http-serv.lua")
                dofile("sms.lua")
                dofile("gpio.lua")
                server = 1
            end
            
         end
     else
         tmr.stop(1)
         getip=wifi.sta.getip()
         connect = 1
         event_disconnect()
         i = 0;
         print("Connected, IP is "..getip.."\n\r")
         if (server == 0) then
                dofile("http-serv.lua")
                dofile("sms.lua")
                dofile("gpio.lua")
                server = 1
         end
         
     end

end)
tmr.start(1)
collectgarbage()

function event_disconnect()
    wifi.eventmon.register(wifi.eventmon.STA_DISCONNECTED, function(T) 
         
         if (disconnect == 0) then
            tmr.start(1)
            print("\n\tSTA - DISCONNECTED".."\n\tSSID: "..T.SSID.."\n\tBSSID: "..
            T.BSSID.."\n\treason: "..T.reason.."\n")
            disconnect = 1
         end
     end)
end

function event_connect()
    wifi.eventmon.register(wifi.eventmon.STA_CONNECTED, function(T) 
     print("\n\tSTA - CONNECTED".."\n\tSSID: "..T.SSID.."\n\tBSSID: "..
     T.BSSID.."\n")
     tmr.start(1)
     disconnect = 0
     end)
end 


