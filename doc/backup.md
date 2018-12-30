# Backup des Raspberry Pi

Ich habe mich entschlossen, gelegentlich eine komplette Sicherung der SD-Karte mit **dd** durchzuführen und regelmäßig eine Sicherung der sich ändernden Dateien.

## Erstellen eines bootfähigen Images
Hierzu _sollte_ der Raspi herunter gefahren werden und die Sicherung auf einem anderen Rechner durchgeführt werden. Sicher ist es auch möglich, die Sicherung auf dem laufenden Raspi selbst durchzuführen; dies ist jedoch weniger sicher, da einige Dateien während des Sicherungsprozesses verändert werden und kein konsistenter Stand gesichert wird. Zur Sicherung selbst verwende ich das uralte Linux-[dd](https://wiki.archlinux.de/title/Image-Erstellung_mit_dd)-Kommando.

- Raspi herunterfahren: `sudo shutdown now`  
- SD-Karte entnehmen und in einen anderen Rechner stecken. Falls die Partitionen automatisch gemounted wurden, diese wieder unmounten.  
- Namen des Devices herausfinden. Z.B. mit: `sudo lsblk`  
- Erstellen des Images: `sudo dd if=/dev/mmcblk0 of=32gb.img bs=4M`  
Für meine [32GB-Karte](./hardware.md#Speicher) hat dies knapp 30 Minuten gedauert.

### Restore eines Images
Der Restore erfolgt mit dem gleichen Kommando wie die Sicherung, aber mit vertauschtem In- und Output.
- Image auf SD-Karte schreiben: `sudo dd if=32gb.img of=/dev/mmcblk0 bs=4M`  
Für meine [32GB-Karte](./hardware.md#Speicher) hat dies ca. 35 Minuten gedauert.

Anschließend die SD-Karte in den Raspi stecken und booten. Das ist erstaunlich einfach und hat gut funktioniert.  
Als ssh mit einer Fehlermeldung antwortet, habe ich in der Datei known_hosts die betreffende Zeile entfernt.
```
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@       WARNING: POSSIBLE DNS SPOOFING DETECTED!          @
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
The ECDSA host key for [pip5knack8zack.myfritz.net]:53122 has changed,
and the key for the corresponding IP address [88.133.133.177]:53122 is unknown. This could either mean that
DNS SPOOFING is happening or the IP address for the host and its host key have changed at the same time.
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@    WARNING: REMOTE HOST IDENTIFICATION HAS CHANGED!     @
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
IT IS POSSIBLE THAT SOMEONE IS DOING SOMETHING NASTY!
Someone could be eavesdropping on you right now (man-in-the-middle attack)!
It is also possible that a host key has just been changed.
The fingerprint for the ECDSA key sent by the remote host is
SHA256:ntUENAIdbA98+hlDrnKDS581oGZdJBsOQvVBB3MMd.
Please contact your system administrator.
Add correct host key in /Users/hajo/.ssh/known_hosts to get rid of this message.
Offending ECDSA key in /Users/hajo/.ssh/known_hosts:28
ECDSA host key for [pip5knack8zack.myfritz.net]:53122 has changed and you have requested strict checking.
Host key verification failed.
```


## Regelmäßiges Backup auf NAS
<img src="https://static.slickdealscdn.com/attachment/1/3/0/7/2/4/5/5/6810047.attach" width="150">  

Auf meinem Western Digital NAS habe ich in Anlehnung an [diese Beschreibung](https://trendblog.net/how-to-mount-your-media-server-or-nas-drive-to-a-raspberry-pi/) einen Share nur für die Backups des Raspberry Pi eingerichtet.

Erstellen des Mount-Point: `sudo mkdir /mnt/myCloud`

Mounten des Shares: `sudo mount 192.168.178.2:/nfs/homeassistant /mnt/myCloud/`

Für die eigentliche Sicherung gibt es eine Vielzahl von Möglichkeiten. Ich nutze aktuell [restic](https://restic.net/):  
Die Installation könnte einfach aus dem Package Manager oder mit `apt-get install restic` erfolgen. Allerdings ist die Version (v0.3.3-1) ziemlich alt.  
Besser ist der Download von [hier](https://github.com/restic/restic/releases/latest). Ich habe im Dezember 2018 die Datei `restic_0.9.3_linux_arm.bz2` herunter geladen.

```
wget https://github.com/restic/restic/releases/download/v0.9.3/restic_0.9.3_linux_arm.bz2
bzip2 -d restic_0.9.3_linux_arm.bz2
chmod a+x restic_0.9.3_linux_arm
sudo mv restic_0.9.3_linux_arm /bin/restic
```

Als nächstes eine Datei mit allen _**nicht**_ zu sichernden Dateien und Verzeichnissen anlegen:
```
sudo echo "/mnt/*
/proc/*
/sys/*
/dev/*
/run/*
/tmp/*" > ~/.restic/restic.excludes
```

Nun das Restic-Repository anlegen: `sudo restic init -r /mnt/myCloud/restic.repo`  
**Wichtig**: Kennwort merken, da man das nicht mehr anzeigen lassen kann!

Durchführen der Sicherung:
```
sudo mount 192.168.178.2:/nfs/homeassistant /mnt/myCloud/
sudo restic backup --exclude-file ~/.restic/restic.excludes -r /mnt/myCloud/restic.repo /
sudo umount /mnt/myCloud
```

## Regelmäßiges Backup
[Hier](https://github.com/vinayaugustine/backup.sh) gibt es ein Script zu Sicherung mit restic, das ich als Vorlage für [mein Script](../RaspiFiles/root/backup.sh) genommen habe, um es dann über den cron auszuführen. Das Script habe ich unter `/root/backup.sh` abgespeichert.

Als erster Schritt wird das Script mit dem Parameter `setup` aufgerufen; hierdurch wird das Kennwort und die Backup-Konfigurationsdatei gespeichert und die Datei mit den nicht zu sichernden Verzeichnissen angelegt. Mit dem Aufruf `./backup.sh backup` wird eine Sicherung durchgeführt.

> Im script noch einen Check einbauen, ob das Verzeichnis gemounted ist. Da der mountpoint existiert, wird sonst auf der SD-Karte selbst "gesichert.""

### crontab
Die crontab-Datei wird mit `crontab -e` editiert. Hier fügt man zwei Zeilen ein:  
`30 11 * * * /root/backup.sh backup`: Tägliche Sicherung um 11:30 Uhr  
`30 12 * * 0 /root/backup.sh prune `: Sonntags um 12:30 Uhr nicht mehr benötigte Dateien aus dem Repository entfernen.

## Vollständiger Restore vom NAS
Auf einem **Mac** ist der Restore nicht möglich, da das rootfs nicht gemounted werden kann!  
Um den Restore auf einem **Linux**-Rechner durchführen zu können, muss zuerst der Sicherungs-Share gemountet werden. Evtl. muss dazu einmalig das Paket nfs-common installiert werden: `sudo apt-get install nfs-common`  
Anschließend mounten des Shares: `sudo mount 192.168.178.2:/nfs/homeassistant /mnt/myCloud/`

- Image auf SD-Karte schreiben: `sudo dd if=32gb.img of=/dev/mmcblk0 bs=4M`  
- Aktualisieren auf den letzten Sicherungsstand: `sudo restic restore -r /mnt/myCloud/restic.repo`  
Da die SD-Karte nicht leer ist, schmeisst restic tausende von Fehlern für Dateien, die es nicht restaurieren kann, weil sie schon vorhanden sind. Im Ergbnis erhält man aber trotzdem einen wiederhergestellen Raspi.

---

Nun noch die [Installation von HomeAssistant](./install_homeassistant.md) und dann kann es _endlich_ losgehen.
