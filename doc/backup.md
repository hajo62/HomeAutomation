# Backup des Raspberry Pi

## Regelmäßiges Backup auf NAS
Auf meinem Western Digital NAS habe ich in Anlehnung an [diese Beschreibung](https://trendblog.net/how-to-mount-your-media-server-or-nas-drive-to-a-raspberry-pi/) einen Share nur für die Backups des Raspberry Pi eingerichtet.

Erstellen des Mount-Point: `sudo mkdir /mnt/myCloud`

Mounten des Shares:
`sudo mount <IP>:/nfs/<Share> /mnt/myCloud/`

Für die eigentliche Sicherung gibt es eine Vielzahl von Möglichkeiten.
Ich nutze aktuell [restic](https://restic.net/):
Die Installation kann einfach aus dem Package Manager oder mit
`apt-get install restic` erfolgen. Allerdings ist die Version (v0.3.3-1) ziemlich alt.
Besser ist der Download von [hier](https://github.com/restic/restic/releases/latest). Ich habe die Datei `restic_0.9.3_linux_arm.bz2` herunter geladen.

```
wget https://github.com/restic/restic/releases/download/latest/restic_0.9.3_linux_arm.bz2
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
sudo mount <IP>:/nfs/<Share> /mnt/myCloud/
sudo restic backup --exclude-file ~/restic.excludes -r /mnt/myCloud/restic.repo /
sudo umount /mnt/myCloud
```

## Regelmäßiges Backup
Über crontab - fehlt noch
