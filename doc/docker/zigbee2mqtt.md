# Zigbee2mqtt

Auf github ist ein [Zigbee zu MQTT](https://github.com/Koenkk/zigbee2mqtt) gateway Projekt verfügbar. Diese Software ermöglicht die Verwendung von Zigbee-Geräten ohne die Bridges oder die Gatewayes der Hersteller und ohne dass Daten in die Cloud der Hersteller übertragen werden.  
Neben der bereits sehr guten Beschreibung des [Autors](https://github.com/Koenkk) gibt es [hier](https://gadget-freakz.com/diy-zigbee-gateway/) und [hier](https://www.panbachi.de/eigenes-zigbee-gateway-bauen-93/) weitere nützliche Artikel und diesen [Forums-Thread](https://community.home-assistant.io/t/zigbee2mqtt-getting-rid-of-your-proprietary-zigbee-bridges-xiaomi-hue-tradfri).

## zigbee2mqtt-Installation mit docker
Eine Beschreibung zur Installation des zigbee2mqtt-Docker-Containers findet sich z.B.  [hier](https://www.zigbee2mqtt.io/information/docker.html).

```
version: '3'
services:
  zigbee2mqtt:
    container_name: zigbee2mqtt
    image: koenkk/zigbee2mqtt:arm32v6
    depends_on:
      - mqtt
    volumes:
      - /home/pi/docker/zigbee2mqtt/data:/app/data
    devices:
      - /dev/serial/by-id/usb-Texas_Instruments_TI_CC2531_USB_CDC___0X00124B00193648CA-if00
    restart: unless-stopped
    network_mode: host
    # environment:
    #   - DEBUG=zigbee-herdsman*
```
