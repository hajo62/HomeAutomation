# Remote-Zugriff auf den Raspberry Pi
Zu allererst muss man prüfen, ob das eigene Netzwerk von *aussen* erreichbar ist. Bei mir musste ich diese [Vorarbeiten](./vorarbeiten.md) durchführen.

Bevor der Raspberry von aussen erreichbar sein wird, _muss_ er entsprechend abgesichert werden. Hierfür wird z.B. *ssh* für root verboten und nur über ein Zertifikat ermöglicht, sowie ein *Remote Proxy* verwendet. Was ich zur Sicherung meines Raspberry Pi eingestellt habe, habe ich unter [Sicherheit](security.md) beschrieben.



Eine gute Bescheibung zu Zertifikaten gibt es [hier](https://tech.europace.de/client-authentifizierung-per-tls/).



## Portfreigabe in FRITZBox einrichten
Eine genaue Beschreibung findet sich [hier](https://avm.de/service/fritzbox/fritzbox-7390/wissensdatenbank/publication/show/893_Statische-Portfreigaben-einrichten/): Der Standartport für ssh ist 22; nach *aussen* kann man nun ebenfalls Port 22 freigeben oder einen beliebigen anderen freien Port wählen. Für VNC muss zusätzlich Port 5900 freigeben werden.
<img src="../images4git/ssh-portfreigabe.jpg" width="700">





---











## GeoIP installieren und konfigurieren
Über GeoIP kann herausgefunden werden, aus welchem Land eine Anfrage kommt, so dass man bestimmte Länder zulassen oder blockieren kann.
```
sudo apt-get install geoip-database libgeoip1
cd /usr/share/GeoIP/
sudo wget http://geolite.maxmind.com/download/geoip/database/GeoLiteCountry/GeoIP.dat.gz
sudo gunzip GeoIP.dat.gz
```
Nun die Datei `/etc/nginx/nginx.conf` bearbeiten und direkt im „http“ Block die GeoIP Einstellungen hinzufügen:
```
    # GeoIP Settings
    # Nur Länder aus erlaubten IP Bereichen dürfen den ReverseProxy
    # passieren!
    # https://www.howtoforge.de/anleitung/nginx-besucher-mit-dem-geoip-modul-nach-landern-blocken-debianubuntu/
    ##
    geoip_country /usr/share/GeoIP/GeoIP.dat;
    map $geoip_country_code $allowed_country {
        default no;
        DE yes;
    }
```
>*Achtung:* Man kommt dann auch selbst nicht durch, wenn man sich im Ausland befindet.

Nun mit `sudo nano /etc/nginx/conf.d/<mydomain>.conf` die Konfigurationsdatei im Server-Block erweitern:
```
server {
    [...]
    ## Blocken, wenn Zugriff aus einem nicht erlaubten Land erfolgt ##
    if ($allowed_country = no) {
        return 444;
    }
    [...]
}
```
Nach dem Neustart von NGINX mit `sudo service nginx restart` ist die Änderung aktiv.

## Weitere Sicherungsmaßnahmen
[Hier](https://www.cyberciti.biz/tips/linux-unix-bsd-nginx-webserver-security.html) kann man einige Einstellungen zur Abwehr von bots, spammern und ähnlichem nachlesen. Es gilt die nginx-Konfigurationsdatei mit `sudo nano /etc/nginx/conf.d/<mydomain>.conf` im Server-Block zu erweitern:
```
if ($http_user_agent ~* LWP::Simple|BBBike|wget) {
    return 403;
}
if ($http_user_agent ~* msnbot|scrapbot) {
    return 403;
}
if ( $http_referer ~* (babes|forsale|girl|jewelry|love|nudit|organic|poker|porn|sex|teen) ) {
    return 403;
}
```

## Client Zertifikat
Für die Sicherung des Raspberry Pi durch Client-Zertifikate gibt es [hier](https://blog.netways.de/2018/08/15/realisierung-einer-clientbasierter-zertifikats-authentifizierung-mutual-ssl-mit-selbstsignierten-zertifikaten-auf-linux-apache/), [hier](https://www.smarthomeng.de/nginx-als-reverseproxy) und [hier](https://medium.com/@pavelevstigneev/setting-nginx-with-letsencrypt-and-client-ssl-certificates-3ae608bb0e66) hilfreiche Anleitungen.

>**Anmerkung:** *pi* in den Dateinamen (z.B. *pi.key*) ist beliebig gewählt.

Erstellung eines eigenen rootca-Zertifikates-Privatekeys mit 4096 bit Schlüssellänge und Encryption des erstellten privaten Keys mit einem Kennwort:

`sudo openssl genrsa -des3 -out /etc/ssl/ca/private/rootca.key 4096`

Erstellen eines Serverzertifikats mit 3 Jahren Gültigkeit:

`sudo openssl req -new -x509 -days 1095 -key /etc/ssl/ca/private/rootca.key -out /etc/ssl/ca/certs/rootca.crt`

Erstellen eines Keys für einen ersten Client. - Hier 4096 oder nur 1024

`sudo openssl genrsa -des3 -out /etc/ssl/ca/certs/users/mac.key 1024`

Für den soeben erstellten Client-Key erstellen wir nun eine Zertifikatsanforderung (CSR):

`sudo openssl req -new -key /etc/ssl/ca/certs/users/mac.key -out /etc/ssl/ca/certs/users/mac.csr`

Jetzt signieren wir die Zertifikatsanforderung (CSR) des Clients gegen unser Serverzertifikat und erstellen ein Client-Zertifikat:

`sudo openssl x509 -req -days 1095 -in /etc/ssl/ca/certs/users/mac.csr -CA /etc/ssl/ca/certs/rootca.crt -CAkey /etc/ssl/ca/private/rootca.key -CAserial /etc/ssl/ca/serial -CAcreateserial -out /etc/ssl/ca/certs/users/mac.crt`

Abschließend exportieren wir das Clientzertifikat und den Key übertragungstauglich in PKCS12-Format:
```
sudo openssl pkcs12 -export -clcerts -in /etc/ssl/ca/certs/users/mac.crt -inkey /etc/ssl/ca/certs/users/mac.key -out /etc/ssl/ca/certs/users/mac.p12

sudo cp /etc/ssl/ca/certs/users/mac.p12 /home/pi
cd /home/pi/
sudo chown pi mac.p12
```

---

---


https://medium.com/@pavelevstigneev/setting-nginx-with-letsencrypt-and-client-ssl-certificates-3ae608bb0e66
https://knowledge.digicert.com/solution/SO25984.html


Erstellung eines eigenen rootca-Zertifikates-Privatekeys mit 4096 bit Schlüssellänge und Encryption des erstellten privaten Keys mit einem Kennwort:

`sudo openssl genrsa -des3 -out /etc/ssl/ca/private/rootca.key 4096`

Erstellen eines Serverzertifikats mit 3 Jahren Gültigkeit:

`sudo openssl req -new -x509 -days 1095 -key /etc/ssl/ca/private/rootca.key -out /etc/ssl/ca/certs/rootca.crt`

Erstellen eines Keys für einen ersten Client. - Hier 4096 oder nur 1024
`sudo openssl genrsa -out /etc/ssl/ca/client.key 4096`

Für den soeben erstellten Client-Key erstellen wir nun eine Zertifikatsanforderung (CSR):

`sudo openssl req -new -key /etc/ssl/ca/client.key -out /etc/ssl/ca/client.csr`

Jetzt signieren wir die Zertifikatsanforderung (CSR) des Clients gegen unser Serverzertifikat und erstellen ein Client-Zertifikat:

`sudo openssl x509 -req -days 1095 -in /etc/ssl/ca/client.csr -CA /etc/ssl/ca/certs/rootca.crt -CAkey /etc/ssl/ca/private/rootca.key -CAserial /etc/ssl/ca/serial -CAcreateserial -out /etc/ssl/ca/client.crt`

#`sudo openssl req -new -x509 -days 365 -key /etc/ssl/ca/client.key -out /etc/ssl/ca/client.crt`

Abschließend exportieren wir das Clientzertifikat und den Key übertragungstauglich in PKCS12-Format:
 `sudo openssl pkcs12 -export -clcerts -in /etc/ssl/ca/client.crt -inkey /etc/ssl/ca/client.key -out /etc/ssl/ca/client.p12`






Das Zertifkat konnte ich nur akzeptieren, wenn ich auf node.js weitergeleitet habe. Nicht bei homeAssistant









---

sudo openssl genrsa -des3 -out /etc/ssl/ca/private/rootca.key 4096
sudo openssl req -new -x509 -days 1095 -key /etc/ssl/ca/private/rootca.key -out /etc/ssl/ca/certs/rootca.crt

sudo openssl ca -name CA_default -gencrl -keyfile /etc/ssl/ca/private/rootca.key -cert /etc/ssl/ca/certs/rootca.crt -out /etc/ssl/ca/private/rootca.crl -crldays 1095

sudo openssl genrsa -out /etc/ssl/ca/client.key 4096


sudo openssl req -new -key /etc/ssl/ca/client.key -out /etc/ssl/ca/client.csr
sudo openssl x509 -req -days 1095 -in /etc/ssl/ca/client.csr -CA /etc/ssl/ca/certs/rootca.crt -CAkey /etc/ssl/ca/private/rootca.key -CAserial /etc/ssl/ca/serial -CAcreateserial -out /etc/ssl/ca/client.crt

sudo openssl req -new -x509 -days 365 -key /etc/ssl/ca/client.key -out /etc/ssl/ca/client.crt
sudo openssl pkcs12 -export -clcerts -in /etc/ssl/ca/client.crt -inkey /etc/ssl/ca/client.key -out /etc/ssl/ca/client.p12


# von rene
ipsec pki --gen --type rsa --size 4096 --outform der > strongswanKey.der
ipsec pki --self --in strongswanKey.der --dn "C=CH, O=strongSwan, CN=hajo" --ca > strongswanCert.der



#!/bin/bash
NAME="Hajo Pross"
USERNAME="hajo"
USERID="hajo"
COUNTRY_CODE=DE
ORGANISATION="hajo CA"

ipsec pki --gen --type rsa --size 2048 --outform der > private/$USERNAME.der

ipsec pki --pub --in private/$USERNAME.der --type rsa | ipsec pki --issue --lifetime 730 --cacert cacerts/strongswan.der --cakey private/strongswan.der --dn "C=$COUNTRY_CODE, O=$ORGANISATION, CN=$USERID" --san "$USERID" --outform der > certs/$USERNAME.der
openssl rsa -inform DER -in private/$USERNAME.der -out private/$USERNAME.pem -outform PEM
openssl x509 -inform DER -in certs/$USERNAME.der -out certs/$USERNAME.pem -outform PEM
openssl pkcs12 -export -inkey private/$USERNAME.pem -in certs/$USERNAME.pem -name "$NAME's VPN Certificate" -certfile cacerts/strongswan.pem -caname "$ORGANISATION Root CA" -out p12/$USERNAME.p12



ipsec pki --gen --type rsa --size 2048 --outform der > $USERNAME.der
ipsec pki --pub --in $USERNAME.der --type rsa | ipsec pki --issue --lifetime 730 --cacert strongswanCert.der --cakey strongswanKey.der --dn "C=$COUNTRY_CODE, O=$ORGANISATION, CN=$USERID" --san "$USERID" --outform der > $USERNAME_Cert.der
openssl rsa -inform DER -in $USERNAME.der -out $USERNAME.pem -outform PEM
openssl x509 -inform DER -in $USERNAME.der -out $USERNAME.pem -outform PEM
openssl pkcs12 -export -inkey $USERNAME.pem -in $USERNAME.pem -name "$NAME's VPN Certificate" -certfile strongswan.pem -caname "$ORGANISATION Root CA" -out $USERNAME.p12




http://www.inanzzz.com/index.php/post/lsto/using-x-509-client-certificate-authentication-with-php-fpm-and-nginx

https://blog.netways.de/2018/08/15/realisierung-einer-clientbasierter-zertifikats-authentifizierung-mutual-ssl-mit-selbstsignierten-zertifikaten-auf-linux-apache/
