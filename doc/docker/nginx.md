# nginx als reverse Proxy konfigurieren

Prüfen, ob das eigene Netzwerk von *aussen* erreichbar ist ([Vorarbeiten](./fritzbox.md)) und den Raspberry absichern ([Security](security.md)).

## nginx-Installation mit docker
Eine Beschreibung zur Installation eines nginx-Docker-Container findet sich z.B.  [hier](https://blog.docker.com/2015/04/tips-for-deploying-nginx-official-image-with-docker); hier hatte ich aber Probleme mit der Konfiguration und mit LetsEncrypt. Eine deutlich einfachere Lösung ist die Nutzung eines Containers, der bereits **nginx** und **LetsEncrypt** enthält.  

Ich habe [diesen](https://github.com/linuxserver/docker-letsencrypt) Container verwendet. Erst später habe ich erfahren, dass es [hier](https://github.com/linuxserver/docker-letsencrypt-armhf) einen speziellen Container für RPi gäbe. Da das Vorgehen mit dem ersten Container nach [dieser](https://community.home-assistant.io/t/nginx-reverse-proxy-set-up-guide-docker) Beschreibung aber gut funktioniert hat, bin ich dabei geblieben.



```
version: '3'
services:
  letsencrypt:
    image: linuxserver/letsencrypt
    container_name: letsencrypt
    restart: unless-stopped
    cap_add:
    - NET_ADMIN
    volumes:
    - /etc/localtime:/etc/localtime:ro
    - /home/user/docker/letsencrypt/config:/config
    environment:
    - PGID=1000
    - PUID=1000
    - EMAIL=hajo62@web.de
    - URL=hajo62.duckdns.org
    - VALIDATION=http
    - TZ=Europe/Berlin
    ports:
    - "80:80"
    - "443:443"
```


letsencrypt    | 2048 bit DH parameters present
letsencrypt    | No subdomains defined
letsencrypt    | E-mail address entered: hajo62@web.de
letsencrypt    | http validation is selected
letsencrypt    | Generating new certificate
letsencrypt    | Saving debug log to /var/log/letsencrypt/letsencrypt.log
letsencrypt    | Plugins selected: Authenticator standalone, Installer None
letsencrypt    | Obtaining a new certificate
letsencrypt    | Performing the following challenges:
letsencrypt    | http-01 challenge for hajo62.duckdns.org
letsencrypt    | Waiting for verification...
letsencrypt    | Cleaning up challenges
letsencrypt    | IMPORTANT NOTES:
letsencrypt    |  - Congratulations! Your certificate and chain have been saved at:
letsencrypt    |    /etc/letsencrypt/live/hajo62.duckdns.org/fullchain.pem
letsencrypt    |    Your key file has been saved at:
letsencrypt    |    /etc/letsencrypt/live/hajo62.duckdns.org/privkey.pem
letsencrypt    |    Your cert will expire on 2019-12-23. To obtain a new or tweaked
letsencrypt    |    version of this certificate in the future, simply run certbot
letsencrypt    |    again. To non-interactively renew *all* of your certificates, run
letsencrypt    |    "certbot renew"
letsencrypt    |  - If you like Certbot, please consider supporting our work by:
letsencrypt    |
letsencrypt    |    Donating to ISRG / Let's Encrypt:   https://letsencrypt.org/donate
letsencrypt    |    Donating to EFF:                    https://eff.org/donate-le









https://medium.com/@pentacent/nginx-and-lets-encrypt-with-docker-in-less-than-5-minutes-b4b8a60d3a71
https://github.com/Tob1asDocker/rpi-certbot
?????
```
docker pull tobi312/rpi-certbot
docker run --name mynginx -P -d nginx
```
