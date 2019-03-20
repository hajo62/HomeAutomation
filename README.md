# Projekt Home Automation
![Latest Version](https://img.shields.io/github/release/hajo62/Homeautomation.svg)

## Wie es begann
Im Herbst 2017 hatte ich mich für Home Automation mit dem Hauptziel der Steuerung mehrerer Heizkörper in meiner angemieteten Wohnung interessiert. Eine zwingende Anforderung war also, dass alle Teile der Home Automation einfach und ohne Zustimmung des Eigentümers zu montieren bzw. wieder zu demontieren sein müssen. Außerdem wollte ich mit Sensoren und Aktoren nicht an einen bestimmten Hersteller gebunden sein. Meine Wahl ist hier auf den Funkstandart [z-wave](https://www.z-wave.com/) gefallen.
Um nicht erst nach Ende der Heizsaison fertig zu sein, habe ich für die Zentrale Steuerungseinheit zuerst nach einer fertigen Lösung gesucht; hier ist meine Wahl auf [homee](https://hom.ee/) gefallen, da homee neben WLAN und z-wave auch [Zigbee](https://www.zigbee.org/)- und [EnOcean](https://www.enocean.com/de/)-Geräte steuern könnte.

Da mir die kommerziellen Produkte aber zu abgeschlossen sind, habe ich im Herbst 2018 begonnen, an einer [Raspberry Pi](https://de.wikipedia.org/wiki/Raspberry_Pi) basierten Lösung zu *basteln*.

- Welche [Hardware](doc/hardware.md) wird benötigt?
- [Betriebssystem](doc/betriebssystem.md) und einige weitere Pakete installieren und ein paar Einstellungen vornehmen.
- Grundlegende Maßnahmen zur [Absicherung](doc/security.md) des Systems durchführen.
- [Internetzugriff](doc/fritzbox.md) auf die FritzBox mit festem Namen zulassen.
- [nginx](doc/nginx.md) installieren und als Remote Proxy konfigurieren.
- [Backup & Recovery](doc/backup.md).
- Installation von [Home Assistant](doc/homeassistant_install.md).
    - Erste  [Sensoren](doc/sensors/sensor_system-monitor.md) konfigurieren.
    - [Gruppen und Tabs](doc/homeassistant_groups_tabs.md) erstellen, um Sensoren geordnet darstellen zu können.
    - [**Zigbee2mqtt**](doc/sensors/zigbee2mqtt.md) konfigurieren, um Zigbee-Sensoren anschließen zu können.
---

Und wie weiter?
- [PlatformIO um Firebeetle](doc/firebeetle.md) anzuschließen?
- **zwave Stick** konfigurieren?
