# Projekt Home Automation

## Wie es begann
Im Herbst 2017 hatte ich mich für Home Automation mit dem Hauptziel der Steuerung mehrerer Heizkörper in meiner angemieteten Wohnung interessiert. Eine zwingende Anforderung war also, dass alle Teile der Home Automation einfach und ohne Zustimmung des Eigentümers zu montieren bzw. wieder zu demontieren sein müssen. Außerdem wollte ich mit Sensoren und Aktoren nicht an einen bestimmten Hersteller gebunden sein. Meine Wahl ist hier auf den Funkstandart [z-wave](https://www.z-wave.com/) gefallen.
Um nicht erst nach Ende der Heizsaison fertig zu sein, habe ich für die Zentrale Steuerungseinhait zuerst nach einer fertigen Lösung gesucht; hier ist meine Wahl auf [homee](https://hom.ee/) gefallen, da homee neben WLAN und z-wave auch [Zigbee](https://www.zigbee.org/) und [EnOcean](https://www.enocean.com/de/) Geräte steuern könnte.

Da mir die kommerziellen Produkte aber zu abgeschlossen sind, habe ich im Herbst 2018 begonnen, an einer [Raspberry Pi](https://de.wikipedia.org/wiki/Raspberry_Pi) basierte Lösung zu *basteln*.

* Welche Hardware?
* [Betriebssystem](doc/betriebssystem.md) installieren
* [Backup](doc/backup.md)
* [Remote-Zugriff](doc/remote.md)
* Installation von [Home Assistant](doc/homeassistant.md)
