# Zigbee2mqtt

Auf github ist ein [Zigbee zu MQTT](https://github.com/Koenkk/zigbee2mqtt) gateway Projekt verfügbar. Diese Software ermöglicht die Verwendung von Zigbee-Geräten ohne die Bridges oder das Gatewayes der Hersteller und ohne dass Daten in die Cloud der Hersteller übertragen werden.  
Neben der bereits sehr guten Beschreibung des [Autors](https://github.com/Koenkk) gibt es [hier](https://gadget-freakz.com/diy-zigbee-gateway/) und [hier](https://www.panbachi.de/eigenes-zigbee-gateway-bauen-93/) weitere nützliche Artikel und diesen [Forums-Thread](https://community.home-assistant.io/t/zigbee2mqtt-getting-rid-of-your-proprietary-zigbee-bridges-xiaomi-hue-tradfri).

## Notwendige Hardware
- [CC2531 Zigbee Sniffer](...): ca. 9 € - Darauf achten, dass der Stick die Debug-Pins zum anstecken das Kabels hat.
- [CC-Debugger](https://rover.ebay.com/rover/1/711-53200-19255-0/1?icep_id=114&ipn=icep&toolid=20004&campid=5338436153&mpre=https%3A%2F%2Fwww.ebay.com%2Fsch%2Fi.html%3F_from%3DR40%26_trksid%3Dm570.l1313%26_nkw%3DCC%2BDebugger%26_sacat%3D0%26LH_TitleDesc%3D0%26_osacat%3D0%26_odkw%3DCC2531%2Bgeh%25C3%25A4use%26LH_TitleDesc%3D0): ca. 9 €
- [Downloader-Kabel](https://rover.ebay.com/rover/1/711-53200-19255-0/1?icep_id=114&ipn=icep&toolid=20004&campid=5338436153&mpre=https%3A%2F%2Fwww.ebay.com%2Fsch%2Fi.html%3F_from%3DR40%26_trksid%3Dm570.l1313%26_nkw%3DBluetooth%2B4.0%2Bzigbee%2Bdownloader%2Bcable%26_sacat%3D0%26LH_TitleDesc%3D0%26_osacat%3D0%26_odkw%3DBluetooth%2B4.0%2Bzigbee%2Bcable%26LH_TitleDesc%3D0): ca. 2 €
- Und als ersten Sensor probiere ich den [Xiaomi Aqara](https://rover.ebay.com/rover/1/711-53200-19255-0/1?icep_id=114&ipn=icep&toolid=20004&campid=5338436153&mpre=https%3A%2F%2Fwww.ebay.com%2Fsch%2Fi.html%3F_from%3DR40%26_trksid%3Dm570.l1313%26_nkw%3DXiaomi%2BAqara%2Btemperature%2Bhumidity%26_sacat%3D0%26LH_TitleDesc%3D0%26_osacat%3D0%26_odkw%3DXiaomi%2BAqara%2Btemperature%26LH_TitleDesc%3D0) für Temperatur, Luftdruck und Feuchtigkeit: ca. 10,50 €

Leider kommen die Teile aus China, so dass es bis zu zwei Monaten dauert, bis sie ankommen. Wer es eiliger hat, findet bei [ebay-Kleinanzeigen](https://www.ebay-kleinanzeigen.de/s-cc2531-zigbee/k0) fertig präperierte Sticks und [hier](https://rover.ebay.com/rover/1/707-53477-19255-0/1?icep_id=114&ipn=icep&toolid=20004&campid=5338436153&mpre=https%3A%2F%2Fwww.ebay.de%2Fsch%2Fi.html%3F_from%3DR40%26_trksid%3Dm570.l1313%26_nkw%3DWSDCGQ11LM%26_sacat%3D0) für ein paar Euro mehr den Xiaomi Aqara Sensor geliefert aus Deutschland.

Ich werde mit diesem Teil erst mal bis Ende Februar warten, da ich das Flashen selbst machen möchte und die anderen Teile nicht in Deutschland gefunden habe...


---

## Flashen der Firmware auf den CC2531 USB Stick
### Vorbereitungen auf dem Mac
[Hier](https://github.com/Koenkk/zigbee2mqtt.io/blob/master/getting_started/flashing_the_cc2531.md) die Bescheibung, um das `cc-tool` zu erstellen:  
```
xcode-select --install
brew install autoconf automake libusb boost pkgconfig libtool
git clone https://github.com/dashesy/cc-tool.git
cd cc-tool
./bootstrap
./configure
make
```

### Flashen der Firmware
Download der Firmware [CC2531ZNP-Prod.hex](https://github.com/Koenkk/Z-Stack-firmware/tree/master/coordinator/CC2531/bin).

Flashen der Firmware:
```
sudo ./cc-tool -e -w /tmp/CC2531ZNP-Prod_20190223/CC2531ZNP-Prod.hex
```
Nun den CC debugger mit dem Downloader cable an den CC2531 USB Sniffer anschließen und denSniffer und den Debugger per USB an den Rechner anschließen. Das Flashen der neuen Firmware erfolgt mit diesem Kommando:
```
sudo ./cc-tool -e -w CC2531ZNP-Prod.hex
```

## Zigbee2mqtt installieren
Zur Installation bin ich dieser [Anleitung](https://github.com/Koenkk/zigbee2mqtt.io/blob/master/getting_started/running_zigbee2mqtt.md) gefolgt.

Prüfen, ob node (>V10.x) und npm (>v6.x) mit den benötigten Versionen installiert sind. Falls nicht, diese installieren.
```
# Checken der node.js- und npm-Versionen und installation von node.js
node --version
npm --version
# Setup Node.js repository
sudo curl -sL https://deb.nodesource.com/setup_10.x | sudo -E bash -

# Install Node.js
sudo apt-get install -y nodejs git make g++ gcc
```

#### Download und Installation der zigbee2mqtt Software:
```
# Clone zigbee2mqtt repository
sudo git clone https://github.com/Koenkk/zigbee2mqtt.git /opt/zigbee2mqtt
sudo chown -R pi:pi /opt/zigbee2mqtt

# Install dependencies
cd /opt/zigbee2mqtt
npm install
```

#### Konfiguration
Mit `nano /opt/zigbee2mqtt/data/configuration.yaml` die Konfigurationsdatei editieren. Hier den MQTT Server, User, Kennwort und den Port prüfen bzw. eintragen.  
`ls -l /dev/serial/by-id` zeigt an, als welches Device der Sniffer erkannt wird. Bei mir war dies `/dev/ttyACM0`. Es kam allerdings vor, dass dies nach dem booten sporadisch auch `/dev/ttyACM01` gewesen ist, so dass ich lieber gleich die Ausgabe von `ls -l /dev/serial/by-id` nutze.

Ich verwende derzeit den im Home Assistant _enthaltenen_ MQTT Broker, so dass die Datei wie folgt ausschaut:  
```
# Home Assistant integration (MQTT discovery)
homeassistant: false

# allow new devices to join
permit_join: true

# MQTT settings
mqtt:
  # MQTT base topic for zigbee2mqtt MQTT messages
  base_topic: zigbee2mqtt
  # MQTT server URL
  server: mqtt://localhost
  # MQTT server authentication, uncomment if required:
  user: homeassistant
  password: myPassword

# Serial settings
serial:
  # Location of CC2531 USB sniffer
  port: /dev/serial/by-id/usb-Texas_Instruments_TI_CC2531_USB_CDC___0X00124B00193648CA-if00
```

mqtt.mdBevor Zigbee2mqtt gestartet wird, sollte der mqtt-Broker (siehe (mqtt.md)[./mqtt.md]) laufen.

#### Zigbee2mqtt starten
```
cd /opt/zigbee2mqtt
npm start
```
Stoppen mit <CTRL + C>.

## Devices pairen
###Xiaomi Aqara pairen.
Dazu den Knopf 5 Sekunden gedrückt halten.

In shell erscheint die Nummer des Devices.

In /opt/zigbee2mqtt/data/configuration.yaml das Device ergänzen:
```
devices:
  '0x00158d0002b5196f':
    friendly_name: 'Temperatur Wohnzimmer'
    retain: false
```
0x00158d0002e23355
.homeassistant/configuration.yaml:
```
discovery: true
discovery_prefix: homeassistant
```


Im HA bei Einstellungen / Integrationen / MQTT findet man die ersten Werte...


sudo nano /etc/systemd/system/zigbee2mqtt.service

[Unit]
Description=zigbee2mqtt
After=network.target

[Service]
ExecStart=/usr/local/bin/npm start
WorkingDirectory=/opt/zigbee2mqtt
StandardOutput=inherit
StandardError=inherit
Restart=always
User=pi

[Install]
WantedBy=multi-user.target


# Start zigbee2mqtt
sudo systemctl start zigbee2mqtt

# Show status
systemctl status zigbee2mqtt.service

sudo systemctl enable zigbee2mqtt.service


# View the log of zigbee2mqtt
sudo journalctl -u zigbee2mqtt.service -f
