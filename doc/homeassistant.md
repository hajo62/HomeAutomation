## Home Assistant

[Hier](https://www.home-assistant.io/docs/installation) gibt es Beschreibungen zu verschiedenen Installationsverfahren für **Home Assistant**. Ich habe mich für die [hier](https://www.home-assistant.io/docs/installation/raspberry-pi/) beschriebene manuelle Installation auf einen bereits vorbereiteten Raspberry Pi entschieden.

Der erste Aufruf des Systems mit dem Kommando `hass` dauert einige Minuten; nach Abschluss ist Home Assistant über `http://<ipaddress>:8123` erreichbar.

<img src="../images4git/ha-create_user.jpg" width="300" border="1">

Nachdem man einen User angelegt hat, muss man sich ein erstes mal anmelden:

<img src="../images4git/ha-first_login.jpg" width="300" border="1">

>**Hinweis:** Bei mir hat der Login nicht funktioniert.
>Erst nachdem ich den hass-Prozess gestoppt und erneut gestartet habe.

### Autostart aktivieren
[Hier](https://www.home-assistant.io/docs/autostart/systemd) gibt es eine Bescheibung, wie man ein Programm beim Systemstart automatisch startet. Mit `sudo nano /etc/systemd/system/home-assistant@homeassistant.service` wird die Datei `home-assistant@homeassistant.service` mit folgendem Inhalt angelegt:

```
[Unit]
Description=Home Assistant
After=network-online.target

[Service]
Type=simple
User=%i
ExecStart=/srv/homeassistant/bin/hass -c "/home/homeassistant/.homeassistant"

[Install]
WantedBy=multi-user.target
```

Reload systemd um die neue Konfiguration bekannt zu machen:

`sudo systemctl --system daemon-reload`

Service enablen, damit dieser nach dem booten gestartet wird:

`sudo systemctl enable home-assistant@homeassistant`

Den Service jetzt **start**en, ohne zu booten. Oder **stop** bzw. **restart**.

`sudo systemctl start home-assistant@homeassistant`

Autostart deaktivieren:

`sudo systemctl disable home-assistant@homeassistant`

### (Optional) Installation von hass.io-Konfigurator
Beim **hass.io-Konfigurator**-Plugin - verfügbar auf [GitHub](https://github.com/danielperna84/hass-configurator) - handelt es sich um einen Web-basierten Editor für die Home Assistant-Konfigurationsdateien mit Syntax-Highlighting. Zur Installation wird die Datei [configurator.py](https://github.com/danielperna84/hass-configurator/blob/master/configurator.py) ins HASS-Homeverzeichnis kopiert, ausführrbar gemacht und ausgeführt.
```
cd /home/homeassistant/.homeassistant
wget https://raw.githubusercontent.com/danielperna84/hass-configurator/master/configurator.py
sudo chown homeassistant configurator.py
sudo chmod a+x configurator.py
```

Mit `sudo nano configuration.yaml` editieren und Folgendes ergänzen:

```
[...]
http:
  api_password: !secret http.api_password
[...]
# Enable Panel iFrames
panel_iframe:
  configurator:
    title: Configurator
    icon: mdi:wrench
    url: !secret configurator_url
[...]    
```
Nun mit `sudo nano configurator.py` editieren und ein frei gewähltes Kenntwort eintragen:
`HASS_API_PASSWORD = "<password>"`

Mit `sudo nano secrets.yaml` das Kennwort und die url zum aufruf des Konfigurators in folgendem Format eintragen:
```
configurator_url: http://<PI-IP>:3218
http.api_password: <password>
```

Im letzten Schritt wird der Konfigurator gestartet und der Home Assistant restartet.
```
sudo ./configurator.py
sudo systemctl restart home-assistant@homeassistant
```

<img src="../images4git/configurator.jpg" width="500" border="1">
