# Sensoren zum Monitoren des Raspberry Pis, des Netzwerkes und der Fritzbox
## Raspberry Pi
### Sensor System Monitor
Die ersten Sensoren, die man zur Verfügung hat, sind die, die der Raspberry Pi - genauer das Betriebssystem - selbst zur Verfügung stellt und die dabei helfen, den Systemzustand im Auge zu behalten. Die verfügbaren Sensoren sind (größtenteils) in der [systemmonitor-Plattform](https://www.home-assistant.io/components/sensor.systemmonitor) zusammen gestellt.  
<img src="../../images4git/system_info.jpg" width="300">

Um diese Sensoren zu aktivieren/darzustellen, müssen die Dateien `sensors.yaml` und `groups.yaml` wie folgt erweitert werden:  
`sensors/sensors.yaml`:
```
####################################################
# Raspberry PI system Monitoring                   #
####################################################
  - platform: systemmonitor
    resources:
      - type: processor_use         # Processur use in %
      - type: memory_use_percent    # Memory used in %
      - type: memory_free           # Memory free in MB
      - type: disk_use_percent      # Disk used in %
        arg: /home                  # arg does really not matter because all folders are in / filesystem located on SD card
      - type: disk_free             # Disk free in MB
        arg: /home
      - type: last_boot             # Time of last boot - needed for template sensor date_last_boot
        #hidden: true               # If hidden, the date_last_boot sensor shows unknown
      - type: network_in            # Network trafic in MB
        arg: wlan0
      - type: network_out
        arg: wlan0                  # Network trafic in MB
  - platform: template
    sensors:
      date_last_boot:               # Last boot in a nicer format: yyyy-mm-dd
        friendly_name: "Date last boot"
        value_template: '{{ states.sensor.last_boot.state.split("T")[0] }}'
```

Nach dem Neustart des HA sind die Sensoren (im Bild sind weitere Sensoren enthalten) in der Übersichtszeile sichtbar:  
<img src="../../images4git/sensors.jpg" width="400">

Damit Sensoren, wie im unteren Teil des Bildes angedeutet, gesammelt in einer Gruppe dargestellt werden, müssen diese gruppiert werden. Wie das geht, ist [hier](../homeassistant_groups_tabs.md) beschrieben.  

### Sensor command line
Mit dem [Command Line Sensor](https://www.home-assistant.io/components/sensor.command_line/) kann man CLI-Kommandos ausführen und die Ausgabe als Sensorwert in das HA-System übernehmen. Auf diese Weise lässt sich z.B. die CPU-Temperatur oder die Uptime des Raspis auslesen. Hier die notwendigen Einträge:
`sensors/sensors.yaml`:
```
- platform: command_line
  name: CPU Temperature           # CPU Temperatur in °C
  command: "cat /sys/class/thermal/thermal_zone0/temp"
  unit_of_measurement: "°C"       # If errors occur, remove degree symbol
  value_template: '{{ value | multiply(0.001) | round(1) }}'
- platform: command_line
  name: UpTime                    # PIs uptime in days
  command: uptime | awk -F'( |,|:)+' '{print $6, $7 ", ", $8, "h"}'
  scan_interval: 3600
  icon: mdi:clock
#  - platform: command_line
#    Does not make so much sense; it's allmost 600 with some peaks at 1400
#    name: CPU Speed                 # Current CPU frequency
#    command: "cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_cur_freq"
#    unit_of_measurement: "MHz"
#    value_template: '{{ value | multiply(0.001) | round(0) }}'
#    scan_interval: 10
```
Hier ein Beispiel für die Ausgabe des Temperatur-Sensors. Um einen solchen Graphen zu erhalten, ist es wichtig, den Parameter `unit_of_measurement` zu pflegen.   
<img src="../../images4git/temperatur.jpg" width="200">
