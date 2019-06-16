# Home Assistant
## Konfigurationen
### Datenbank-Größe verringern
#### Manuell
Um die Datenbank (/home/homeassistant/.homeassistant/home-assistant_v2.db) manuell zu verkleinern, kann man auf der Seite **Services** den Dienst **recurder.purge** starten. Um. z.B die Werte der letzten 7 Tage in der Datenbank zu behalten, übergibt man folgende Werte:  
```
{
  "keep_days":"7",
  "repack":"true"
}
```
<img src="../images4git/recorder_purge.jpg" width="300" border="1">

Das Verkleinern der Datenbank dauert einige Minuten.
