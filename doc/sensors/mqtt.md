In configuration.yaml:
```
# Enable internal mqtt broker
mqtt:
  discovery: false
  discovery_prefix: homeassistant
  password: !secret mqtt_password
```

Wenn neue Sensoren automatisch gefunden werden sollen, muss der Wert auf `discovery: true` geändert werden.

Erstes Beispiel: https://www.home-assistant.io/cookbook/python_component_mqtt_basic
Anschließend auf Entwicklerwerkzeuge gehen und über Service den erstellten Service aufrufen. Payload steht im Beispiel.

https://community.home-assistant.io/t/using-mqtt-with-home-assistant/42501
```
sensor:
# mqtt-Spielkram
  - platform: mqtt
    name: "Stimmung"
    state_topic: "home-assistant/hajo/stimmung"
```
Message senden mit `mosquitto_pub  -V mqttv311 -u homeassistant -P hajo -t "some_mqtt/topic/here" -m "Meine erste MQTT-Message"`.
mosquitto_pub installieren mit: `sudo apt-get install mosquitto-clients`


Für MQTT in PlatformIO die PubSubClient-Library installieren.




---


https://github.com/Koenkk/zigbee2mqtt/issues/new
I'm running HA 0.89.2 on Raspbian on Pi B3+
I'm using the embedded MQTT broker as described here: https://www.home-assistant.io/docs/mqtt/broker#embedded-broker
Flashed the CC2531 as described here: https://github.com/Koenkk/zigbee2mqtt.io/blob/master/getting_started/flashing_the_cc2531.md
Did the installation as described here: https://github.com/Koenkk/zigbee2mqtt.io/blob/master/getting_started/running_zigbee2mqtt.md

When I run the npm start, is see this error:

```
2019-3-15 15:00:24 - info: Logging to directory: '/opt/zigbee2mqtt/data/log/2019-03-15.15-00-24'
2019-3-15 15:00:25 - info: Starting zigbee2mqtt version 1.2.1 (commit #e5ca977)
2019-3-15 15:00:25 - info: Starting zigbee-shepherd
2019-3-15 15:00:25 - info: zigbee-shepherd started
2019-3-15 15:00:25 - info: Coordinator firmware version: '20190223'
2019-3-15 15:00:25 - info: Currently 0 devices are joined:
2019-3-15 15:00:25 - warn: `permit_join` set to  `true` in configuration.yaml.
2019-3-15 15:00:25 - warn: Allowing new devices to join.
2019-3-15 15:00:25 - warn: Set `permit_join` to `false` once you joined all devices.
2019-3-15 15:00:25 - info: Zigbee: allowing new devices to join.
2019-3-15 15:00:25 - info: Connecting to MQTT server at mqtt://localhost
2019-3-15 15:00:25 - info: zigbee-shepherd ready
2019-3-15 15:00:37 - error: Not connected to MQTT server!
2019-3-15 15:00:37 - error: Cannot send message: topic: 'zigbee2mqtt/bridge/state', payload: 'offline
2019-3-15 15:00:37 - info: zigbee-shepherd stopped
```
