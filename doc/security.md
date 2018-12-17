# Security
## ssh
###	ssh für root ausschalten
Siehe z.B. [Securing Home Assistant](https://www.home-assistant.io/docs/configuration/securing), [Sichere SSH Konfiguration](https://blog.buettner.xyz/sichere-ssh-konfiguration) und [Absicherung eines Debian Servers](https://www.thomas-krenn.com/de/wiki/Absicherung_eines_Debian_Servers#SSH_Konfiguration).
> *Anmerkung: Falls ssh nicht installiert ist, mit `sudo apt-get install ssh` installieren. Sollte der Dienst sich nicht automatisch starten, den Befehl `sudo update-rc.d ssh defaults` ausführen.*

Um den login für den Nutzer root zu deaktivieren, wird in der Datei `/etc/ssh/sshd_config` die Zeile `PermitRootLogin prohibit-password` aktiviert; nun ist auch bei Kenntnis des root-Kennwortes keine Anmeldung über ssh möglich.
> *Anmerkung: Bei mir war die Anmeldung auch vorher nicht möglich.*

### ssh Standartport 22 verändern
In der Konfigurationsdatei `/etc/ssh/sshd_config` einen Port oberhalb von 1023 eintragen.
```
[...]
Port 53122
#AddressFamily any
[...]
```
Nun noch mit `sudo service ssh restart` den ssh-Dämon neu starten, damit die geänderte Konfiguration aktiv wird. Ab jetzt muss bei jedem Remote Login der Port mit angegeben werden:  
`ssh pi@192.168.178.111 -p 53122`

### OpenSSH Public Key Authentifizierung konfigurieren
Zuerst wird auf dem _Client_ das Schlüsselpaar - bestehend aus public und private key - generiert und anschließend der public key zum Server übertragen. Der Private Schlüssel sollte mit einem Kennwort gesichert werden.

Schlüsselpaar generieren:  
`ssh-keygen -b 4096 -f ~/.ssh/pi_rsa`

Öffentlichen Schlüssel auf den Ziel-Server übertragen:  
`ssh-copy-id -i ~/.ssh/pi_rsa.pub -p 53122 pi@192.168.178.111`

#### Privaten Schlüssel in keychain speichern
Da es lästig ist, immer wieder das Kennwort für den private key eingeben zu müssen, kann man diesen in der keychain des eigenen Clients speichern. Unter MacOS sieht geschieht dies mit:  
`ssh-add -K ~/.ssh/pi_rsa`

Von nun ist es möglich, von diesem Client den Pi ohne Eingabe eines Kennwortes zu erreichen. Auch das _passende_ Zertifikat wird automatisch _gefunden_:
```
ssh -p 53122 pi@192.168.178.111
sftp -P 53122 pi@192.168.178.111
scp -P 53122 /tmp/tst pi@192.168.178.111:/tmp/tst
```

#### Permission denied (publickey)
Nach einem Update meines Macs auf Mojave funktionierte der ssh-Login nicht mehr. Abhilfe schuf das Kommando `ssh-add ~/.ssh/pi_rsa`:
```
ssh-add ~/.ssh/pi_rsa
Enter passphrase for /Users/hajo/.ssh/pi_rsa:
Identity added: /Users/hajo/.ssh/pi_rsa (/Users/hajo/.ssh/pi_rsa)
```


### ssh-login mit Kennwort deaktivieren
> **Achtung:** Wenn dies durchgeführt ist, kann man den Pi über ssh nicht mehr ohne die Private-Key-Datei erreichen!

In der Konfigurationsdatei `/etc/ssh/sshd_config` den Schlüssel `PasswordAuthentication` auf `no` setzen.
```
[...]
# To disable tunneled clear text passwords, change to no here!
PasswordAuthentication no
#PermitEmptyPasswords no
[...]
```

Nun wie schon bekannt, den ssh-Dämon neu starten:  
`sudo service ssh restart`

Ein Anmeldeversuch von einem Rechner ohne Zertifikat führt nun zu:  
`pi@192.168.178.111: Permission denied (publickey).`

Wenn man nun einen weiteren Client zulassen möchte, muss man kurzfristig den ssh-login mit Kennwort wieder aktivieren.

---
## Reverse Proxy mit nginx
### nginx installieren
Der Webserver [nginx](https://de.wikipedia.org/wiki/Nginx) kann u.a. auch als [Reverse-Proxy](https://de.wikipedia.org/wiki/Reverse_Proxy) zur Erhöhung der Sicherheit eingesetzt werden. Eine Beschreibung zur Installation findet sich z.B.  [hier](https://howtoraspberrypi.com/install-nginx-raspbian-and-accelerate-your-raspberry-web-server).  
Im November 2018 war im Raspbian-Paketrepository eine ziemlich alte nginx-Version **(v1.10)** verfügbar. Zwischenzeitlich gibt es neue Versionen, die vermeintlich schneller und sicherer seien. Ein wenig weiter [unten](#nginx auf aktuellere version bringen) habe ich die Installation der aktuellen Version beschreiben.  

```
sudo apt install nginx php-fpm
sudo nginx
```

>**Anmerkung** Ich hatte hier beim ersten Start eine Fehlermeldung:
```
nginx: [emerg] bind() to 0.0.0.0:80 failed (98: Address already in use)
nginx: [emerg] bind() to [::]:80 failed (98: Address already in use)
```
Tat es aber trotzdem... Falls nicht:
`sudo fuser 80/tcp` zeigt die Prozesse, die auf Port 80 zugreifen und `sudo fuser -k 80/tcp` stoppt die Prozesse.

Anschließend auf dem Pi im Browser `http://localhost` oder auf dem Client `http://192.168.178.111` aufrufen, um die Funktion zu überprüfen:  
<img src="../images4git/nginx-welcome.jpg" width="700">

#### Warum php-fpm?
In den Paketrepositories ist Nginx nicht an PHP gebunden. Bei der Entwicklung von Nginx wurde die Entscheidung getroffen, PHP-FMP (eine schnellere Version von PHP) anstelle eines herkömmlicheren PHP zu verwenden. Daher werden wir php-fpm installieren, um PHP-Dateien mit Nginx zu verwalten.

### nginx auf aktuellere Version bringen
Allerdings ist die aktuelle Version **(v1.14.1)** nicht ganz so einfach zu installieren, da man hierfür den **testing branch** von **Raspbian** den Paketquellen hinzufügen muss. Eine Beschreibung der Installation habe ich [hier](https://getgrav.org/blog/raspberrypi-nginx-php7-dev) gefunden.

Anlegen der Datei `/etc/apt/sources.list.d/10-buster.list` mit folgendem Inhalt:  
`deb http://mirrordirector.raspbian.org/raspbian/ buster main contrib non-free rpi`

Anlegen der Datei `/etc/apt/sources.list.d/10-buster` mit folgendem Inhalt:  
```
Package: *
Pin: release n=stretch
Pin-Priority: 900

Package: *
Pin: release n=buster
Pin-Priority: 750
```

Die Installation erfolgt mit den nachstehenden Kommandos. Hierbei habe ich alle Default-Werte akzeptiert
```shell
sudo apt-get update
sudo apt-get install -t buster nginx
```

Bei mir ist Installation nicht _glatt_ durchgelaufen; zwei der Meldungen habe ich mir zur Sicherheit [hier](./nginx_update_errors.md) aufgehoben.


### nginx starten beim booten
>**Anmerkung:** War bei mir auch ohne dies Kommando bereits autostart.

Ausführen des Kommandos:  
`sudo update-rc.d -f nginx defaults`


### NGINX als ReverseProxy konfigurieren
[Hier](https://www.smarthomeng.de/nginx-als-reverseproxy) und [hier](https://www.home-assistant.io/docs/ecosystem/certificates/lets_encrypt) gibt es eine sehr ausführliche Beschreibung, wie man sein Home Automation durch einen Reverse Proxy mit SSL-Zertifikat (siehe [hier](https://goneuland.de/debian-9-stretch-lets-encrypt-zertifikate-mit-certbot-erstellen/)) absichern kann.

<!---
Die im Repo vorhandene Version ist recht alt (Nov 18: v0.10.2).
Daher nutze ich das Installationsskript. Darauf achten, dass Port 80 vorübergehend auf den Raspberry weitergeleitet wird (siehe [Portfreigabe](./remote.md#portfreigabe-in-fritzbox-einrichten)).
-->

#### Erstellen eines Zertifikates mit LetsEncrypt:
##### Vorbereitende Einstellungen
Vor der Erstellung des Zertifikates sind noch einige Einstellungen zu machen.

Damit `certbot:` die Identität überprüfen kann:

Mit `sudo nano /etc/nginx/snippets/letsencrypt.conf` eine Datei anlegen und folgenden Inhalt eingeben.
```
location ^~ /.well-known/acme-challenge/ {
 default_type "text/plain";
 root /var/www/letsencrypt;
}
```
Anschließend folgende Kommandos ausführen:
```
sudo mkdir -p /var/www/letsencrypt/.well-known/acme-challenge
sudo nano /etc/nginx/sites-available/default
```
Nun unterhalb von `listen [::]:80 default_server;` die Zeile `include /etc/nginx/snippets/letsencrypt.conf;` einfügen, so dass die eben erstellte Datei inkludiert wird.
```
server {
        listen 80 default_server;
        listen [::]:80 default_server;
        include /etc/nginx/snippets/letsencrypt.conf;
[...]
```
Mit `sudo service nginx restart` nginx neu starten.

##### Zertifikat erzeugen
```
cd
mkdir certbot
cd certbot/
wget https://dl.eff.org/certbot-auto
chmod u+x certbot-auto
sudo ./certbot/certbot-auto certonly --rsa-key-size 4096 --webroot -w /var/www/letsencrypt --email <myMail> -d <myDNSName>
```

Beim ersten Aufruf wird die benötigte Software installiert, bei späteren Aufrufen ggf. aktualisiert (0.29.1) und anschließend das Zertifikat herunter geladen. Mit dem Kommando `sudo ls -l /etc/letsencrypt/live` kann man überprüfen, dass ein Ordner mit dem Namen der eigenen dynDNS angelegt wurde.
(Warum soll man Port 80 freigaben)

Nun noch mit `sudo nano /etc/nginx/conf.d/<mydomain>.conf` die Konfigurationsdatei für die eigene Domäne erstellen. Hier der erste minimale Inhalt dieser Datei in Anlehnung an das oben erwähnte [Tutorial](https://www.smarthomeng.de/nginx-als-reverseproxy).

```
server {
    listen 443 ssl default_server;
    server_name <myDNSName>;

    ##
    # SSL
    ##
    ## Activate SSL, setze SERVER Zertifikat Informationen ##
    # Generiert via Let's Encrypt!
    ssl on;
    ssl_certificate /etc/letsencrypt/live/<myDNSName>/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/<myDNSName>/privkey.pem;
    ssl_session_cache builtin:1000 shared:SSL:10m;
    ssl_prefer_server_ciphers on;
    # unsichere SSL Ciphers deaktivieren!
    ssl_ciphers    HIGH:!aNULL:!eNULL:!LOW:!3DES:!MD5:!RC4;

    ##
    # HSTS
    ##
    add_header Strict-Transport-Security "max-age=31536000; includeSubDomains" always;

    ##
    # global
    ##
    root /var/www/<myDNSName>;
    index index.php index.htm index.html;

    # Weiterleitung von allen über https eingehenden Calls auf einen nodejs-Testserver
    location / {
        proxy_pass      http://127.0.0.1:3000;
        proxy_buffering off;
    }
}
```

##### Zertifikat erneuern
Mit `sudo ./certbot/certbot-auto renew --dry-run` kann man testen, ob die automatische Erneuerung des Zertifikates funktionieren würde.




---

sshguard?
https://www.pilgermaske.org/2018/06/sshguard-schnell-und-einfach-ssh-absichern/
