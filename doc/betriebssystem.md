## Betriebssystem installieren
Ich hatte meinen Laptop viele Jahre mit ubuntu betrieben, so dass ich den Raspberry auch gern mit diesem Betriebssystem betrieben möchte. Aktuell (November 2018) ist aber leider noch keine [offizielles Image](https://www.raspberrypi.org/downloads/) für meinen Raspberry Pi 3 B+ verfügbar. Es gibt diverse Beschreibungen und ein inoffizielles [Image](https://pi-buch.info/ubuntu-mate-18-04-fuer-den-raspberry-pi-3b/) für ubuntu mate 18.04; ich war damit aber leider nicht erfolgreich.

Deshalb nutze ich bis auf weiteres [Raspbian Stretch with desktop](https://www.raspberrypi.org/downloads/raspbian). Die Installation geht mit diesem Image sehr einfach und hat darüber hinaus den Vorteil, dass man weder einen Monitor, noch eine Tastatur an den Raspberry anschließen muss.
* Download des [Images](https://downloads.raspberrypi.org/raspbian_latest). Das kleinere **Strech Lite** ohne Desktop wäre auch ausreichend.

* Das Image auf eine SD-Karte flashen.
Hierzu wird [Etcher](https://www.balena.io/etcher/) empfohlen.

* **ssh** für den Remotezugriff aktivieren:
Dazu muss man lediglich mit `touch /Volumes/boot/ssh` eine leere Datei `ssh` auf der boot-Partition auf der sd anlegen. (Je nach genutztem Rechner kann sich der Mount-Point "/Volumes" unterscheiden.)
* **wlan** aktivieren und konfigurieren:
Ein Beschreibung dazu findet sich [hier](https://pi-buch.info/wlan-schon-vor-der-installation-konfigurieren).
Dazu mit `nano /Volumes/boot/wpa_supplicant.conf` eine Datei im root-Verzeichnis der boot-Partition auf der SD-Karte anlegen und folgenden Inhalt eingeben:
```
country=DE
ctrl_interface=DIR=/var/run/wpa_supplicant GROUP=netdev
update_config=1
network={
       ssid="wlan-bezeichnung"
       psk="passwort"
       key_mgmt=WPA-PSK
}
```
Die SD-Karte in den Raspberry einlegen und diesen einschalten. Nach vielleicht einer Minute sollte sich der Raspberry im Netzwerk angemeldet haben und über `ssh pi@<ip-adresse>` erreichbar sein.

Nun gilt es noch ggf. vorhandene Updates einzuspielen:
Dazu einloggen auf dem Raspberry Pi und mit apt-get aktualisieren.
```
sudo apt-get update
sudo apt-get upgrade
```

Um auch den Desktop des Raspberry Pi remote öffnen zu können, installiert man einfach [VNC](https://wiki.ubuntuusers.de/VNC/).
```
sudo apt-get install realvnc-vnc-server realvnc-vnc-viewer
sudo raspi-config
```

Zum Menüpunkt **Interfacing Options** gehen;  anschließend zur Option **VNC** und dieses aktivieren.
<img src="../images4git/activate-vnc.jpg" width="700">

Da der Raspberry Pi über keine Echtzeituhr ([Real Time Clock - RTC](https://de.wikipedia.org/wiki/Echtzeituhr)) verfügt, sollte man die Zeit mit einem NTP-Zeitdienst automatisch aktualisieren. Mit dem Kommando `timedatectl status` lässt sich der Status überprüfen. Nach meiner Interpretation bedeuten  `Network time on: yes`und `NTP synchronized: yes`, dass dies per Default aktiviert ist.