# Remote-Zugriff auf den Raspberry Pi
Zu allererst muss dass eigene Netzwerk von *aussen* erreichbar sein. Die dazu notwendigen Arbeiten sind hier [hier](./vorarbeiten.md) beschrieben.

Bevor der Raspberry nun von aussen erreichbar sein wird, muss er entsprechend abgesichert werden.

##	ssh für root ausschalten
Siehe z.B. [Securing Home Assistant](https://www.home-assistant.io/docs/configuration/securing) und [Sichere SSH Konfiguration](https://blog.buettner.xyz/sichere-ssh-konfiguration).
Dazu in der Datei `/etc/ssh/sshd_config` die Zeile `PermitRootLogin prohibit-password` aktivieren, so dass man sich per ssh auch bei Kenntnis des Kennwortes nicht als root anmelden darf.

>*Anmerkung: Bei mir war die Anmeldung auch vorher nicht möglich.*

## Portfreigabe in FRITZBox einrichten
Eine genaue Beschreibung findet sich [hier](https://avm.de/service/fritzbox/fritzbox-7390/wissensdatenbank/publication/show/893_Statische-Portfreigaben-einrichten/): Der Standartport für ssh ist 22; nach *aussen* kann man nun ebenfalls Port 22 freigeben oder einen beliebigen anderen freien Port wählen. Für VNC muss zusätzlich Port 5900 freigeben werden.
<img src="../images4git/ssh-portfreigabe.jpg" width="700">

## nginx
Der Webserver [nginx](https://de.wikipedia.org/wiki/Nginx) kann u.a. auch als [Reverse-Proxy](https://de.wikipedia.org/wiki/Reverse_Proxy) zur Erhöhung der Sicherheit eingesetzt werden. Eine Beschreibung zur Installation findet sich [hier](https://howtoraspberrypi.com/install-nginx-raspbian-and-accelerate-your-raspberry-web-server).

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

Anschließend im Browser `http://localhost` aufrufen, um die Funktion zu überprüfen:
<img src="../images4git/nginx-welcome.jpg" width="700">

### Warum php-fpm?
By default, Nginx is not bound to PHP. During the development of Nginx, the choice was made to use PHP-FMP (a faster version of PHP) rather than a more traditional PHP. Therefore, we will install php-fpm to manage PHP files with Nginx.

## nginx starten beim booten
>**Anmerkung:** War bei mir auch ohne dies Kommando bereits autostart.

Ausführen des Kommandos: `sudo update-rc.d -f nginx defaults`

---

## NGINX als ReverseProxy konfigurieren
[Hier](https://www.smarthomeng.de/nginx-als-reverseproxy) und [hier](https://www.home-assistant.io/docs/ecosystem/certificates/lets_encrypt) gibt es eine sehr ausführliche Beschreibung, wie man sein Home Automation durch einen Reverse Proxy mit SSL-Zertifikat (siehe [hier](https://goneuland.de/debian-9-stretch-lets-encrypt-zertifikate-mit-certbot-erstellen/)) sichern kann.

Die im Repo vorhandene Version ist recht alt (Nov 18: v0.10.2). Daher nutze ich das Installationsskript. Darauf achten, dass Port 80 vorübergehend auf den Raspberry weitergeleitet wird [Portfreigabe](#portfreigabe-in-fritzbox-einrichten).

Vor der Erstellung des Zertifikates sind noch eine Einstellungen zu machen:

Damit certbot die Identität überprüfen kann:

Mit `sudo nano /etc/nginx/snippets/letsencrypt.conf` eine Datei anlegen und folgenden Inhalt eingeben.
```
location ^~ /.well-known/acme-challenge/ {
 default_type "text/plain";
 root /var/www/letsencrypt;
}
```
```
sudo mkdir -p /var/www/letsencrypt/.well-known/acme-challenge
sudo nano /etc/nginx/sites-available/default
```
Dort unterhalb von `listen [::]:80 default_server;` die Zeile `include /etc/nginx/snippets/letsencrypt.conf;`  einfügen.
```
server {
        listen 80 default_server;
        listen [::]:80 default_server;
        include /etc/nginx/snippets/letsencrypt.conf;
[...]
```
Nun mit `sudo service nginx restart` nginx neu starten.

### Zertifikat erzeugen
```
cd
mkdir certbot
cd certbot/
wget https://dl.eff.org/certbot-auto
chmod u+x certbot-auto

sudo ./certbot/certbot-auto certonly --rsa-key-size 4096 --webroot -w /var/www/letsencrypt --email <myMail> -d <myDNSName>
```

Beim ersten Aufruf wird hier die benötigte Software installiert und anschließend das Zertifikat herunter geladen. Mit dem Kommando `sudo ls -l /etc/letsencrypt/live` kann man überprüfen, dass ein Ordner mit dem Namen der eigenen dynDNS angelegt wurde.

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

    # Weiterleitung von allen über https eingehenden Calls auf den nodejs-Testserver
    location / {
        proxy_pass      http://127.0.0.1:3000;
        proxy_buffering off;
    }
}
```
