# esp8266-security-wifi-sms

# This is WiFi Security system on ESP8266. Works with SMS-gateway, hardware (e.g. smartphone, modem etc.) and software (sending and receive SMS via internet). When use hardware SMS-gateway access to the internet is optional. (I used my HTC One V and SMS Gateway Ultimate Pro) 

I used the SoC ESP8266 on board ESP-12 but you can use any board except ESP-01 and other boards which doesn't contain the GPIO2 GPIO4 GPIO5 GPIO13 GPIO15 pins.

Before flash the board, create and flash the file "settings.txt" which contains:
sta_ssid=[station_ssid];sta_pass=[station_password];ap_ssid=[AP_SSID];ap_pass=[AP_password];port=80;
