# Remote-Zugriff auf den Raspberry Pi
Zu allererst muss dass eigene Netzwerk von *aussen* erreichbar sein. Die dazu notwendigen Arbeiten sind hier [hier](./vorarbeiten.md) beschrieben.

Bevor der Raspberry nun von aussen erreichbar sein wird, muss er entsprechend abgesichert werden.

##	ssh für root ausschalten
Siehe z.B. [Securing Home Assistant](https://www.home-assistant.io/docs/configuration/securing) und [Sichere SSH Konfiguration](https://blog.buettner.xyz/sichere-ssh-konfiguration).
Dazu in der Datei `/etc/ssh/sshd_config` die Zeile `PermitRootLogin prohibit-password` aktivieren, so dass man sich per ssh auch bei Kenntnis des Kennwortes nicht als root anmelden darf.
*Anmerkung: Bei mir war die ANmeldung auch vorher nicht möglich.*
