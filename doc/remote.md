# Remote-Zugriff auf den Raspberry Pi
Zu allererst muss dass eigene Netzwerk von *aussen* erreichbar sein. Die dazu notwendigen Arbeiten sind hier [hier](./vorarbeiten.md) beschrieben.

Bevor der Raspberry nun von aussen erreichbar sein wird, muss er entsprechend abgesichert werden.

##	ssh für root ausschalten
Siehe z.B. [Securing Home Assistant](https://www.home-assistant.io/docs/configuration/securing) und [Sichere SSH Konfiguration](https://blog.buettner.xyz/sichere-ssh-konfiguration).
Dazu in der Datei `/etc/ssh/sshd_config` die Zeile `PermitRootLogin prohibit-password` aktivieren, so dass man sich per ssh auch bei Kenntnis des Kennwortes nicht als root anmelden darf.

*Anmerkung: Bei mir war die Anmeldung auch vorher nicht möglich.*

## nginx
Der Webserver [nginx](https://de.wikipedia.org/wiki/Nginx) kann u.a. auch als [Reverse-Proxy](https://de.wikipedia.org/wiki/Reverse_Proxy) zur Erhöhung der Sicherheit eingesetzt werden. Eine Beschreibung zur Installation findet sich [hier](https://howtoraspberrypi.com/install-nginx-raspbian-and-accelerate-your-raspberry-web-server).

```
sudo apt install nginx php-fpm
sudo nginx
```

**Anmerkung** Ich hatte hier beim ersten Start eine Fehlermeldung:
```
nginx: [emerg] bind() to 0.0.0.0:80 failed (98: Address already in use)
nginx: [emerg] bind() to [::]:80 failed (98: Address already in use)
```
Tat es aber trotzdem... Falls nicht:
`sudo fuser 80/tcp` zeigt die Prozesse, die auf Port 80 zugreifen und `sudo fuser -k 80/tcp` stoppt die Prozesse.

Anschließend im Browser `http://localhost` aufrufen, um die Funktion zu überprüfen:
<img src="../images4git/nginx-welcome.jpg" width="700">

### Warum php-fpm?
By default, Nginx is not bound to PHP. During the development of Nginx, the choice was made to use PHP-FMP (a faster version of PHP) rather than a more traditional PHP. Therefore, we will install php-fpm to manage PHP files with Nginx.

## nginx starten beim booten
**Anmerkung:** War bei mir auch ohne dies Kommando bereits autostart.

Ausführen des Kommandos: `sudo update-rc.d -f nginx defaults`
