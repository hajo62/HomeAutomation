# security

##	ssh für root ausschalten
Siehe z.B. [Securing Home Assistant](https://www.home-assistant.io/docs/configuration/securing) und [Sichere SSH Konfiguration](https://blog.buettner.xyz/sichere-ssh-konfiguration).

Um den login für den Nutzer root zu deaktivieren, wird in der Datei `/etc/ssh/sshd_config` die Zeile `PermitRootLogin prohibit-password` aktiviert; nun ist auch bei Kenntnis des root-Kennwortes keine Anmeldung über ssh möglich.
>* **Anmerkung:** Bei mir war die Anmeldung auch vorher nicht möglich.*
