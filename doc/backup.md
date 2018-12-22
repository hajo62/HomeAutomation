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
echo "/mnt/*
/proc/*
/sys/*
/dev/*
/run/*
/tmp/*" > ~/restic.excludes
```

Nun das Restic-Repository anlegen: `restic init -r /mnt/myCloud/restic.repo`  
**Wichtig**: Kennwort merken, da man das nicht mehr anzeigen lassen kann!

Durchführen der Sicherung:
```
sudo mount 192.168.178.2:/nfs/homeassistant /mnt/myCloud/
sudo restic backup --exclude-file ~/restic.excludes -r /mnt/myCloud/restic.repo /
sudo umount /mnt/myCloud
```

## Regelmäßiges Backup
Über crontab - fehlt noch
