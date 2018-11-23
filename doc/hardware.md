# Raspberry Pi 3 Model B+
Das aktuelle Modell (Nov 2018) hat einen 64-Bit-Quad-Core-Prozessor mit 1.4GHz, 1 GB RAM, Dualband-WLAN mit 2.4GHz und 5GHz, Bluetooth 4.2/BLE und schnelleres Ethernet.

Den Raspberry Pi gibt es für unter 40€ z.B. [hier](https://rover.ebay.com/rover/1/707-53477-19255-0/1?icep_id=114&ipn=icep&toolid=20004&campid=5338436153&mpre=https%3A%2F%2Fwww.ebay.de%2Fitm%2FNeu-Raspberry-Pi-3-Model-B-BCM2837B0-SoC-IoT-PoE-Enabled-RP01048%2F273110053778%3Fepid%3D19018199270%26hash%3Ditem3f96a0b392%3Ag%3A-K4AAOSwIKNb8-u1)\*.

<img src="https://www.raspberrypi.org/app/uploads/2018/03/770A5842-1612x1080.jpg" width="400">

## Speicher
Als permanenter Speicher (Ersatz für eine Festplatte) für den Raspberry wird zuerst meist eine SD-Karte verwendet. Das Risiko hier ist aber die relativ geringe Haltbarkeit durch die limitierte Überschreibbarkeit, die von den Herstellern mit ca. 10.000 bis 100.000 Schreibzyklen angegeben wird. Die Ursache für den schnellen Ausfall ist das häufige Beschreiben der selben Speicherstellen, da SD-Karten meist kein ausreichendes _[wear leveling](https://www.chip.de/artikel/SSD-So-haelt-die-Hightech-Festplatte-8x-laenger-3_139999723.html)_ aufweisen.

Sicher besser und haltbarer ist hier eine SSD-Festplatte, wie z.B. [diese](https://rover.ebay.com/rover/1/707-53477-19255-0/1?icep_id=114&ipn=icep&toolid=20004&campid=5338436153&mpre=https%3A%2F%2Fwww.ebay.de%2Fitm%2FSamsung-860-EVO-PRO-250GB-256GB-500GB-interne-SSD-mSATA-M-2-6-4cm-2-5-SATA3%2F123462925494%3Fhash%3Ditem1cbef6bcb6%3Am%3AmummlD9WCq-X-UKwFKZ3fGQ%3Ark%3A1%3Apf%3A0%26LH_ItemCondition%3D1000%26LH_BIN%3D1)\*. Einen Geschwindigkeitsvorteil konnte ich nicht beobachten; vermutlich weil die SSD über den USB-Port angeschlossen ist.

Unabhängig davon habe ich mich derzeit noch für [diese](https://rover.ebay.com/rover/1/707-53477-19255-0/1?icep_id=114&ipn=icep&toolid=20004&campid=5338436153&mpre=https%3A%2F%2Fwww.ebay.de%2Fitm%2FSANDISK-Ultra-UHS-I-Micro-SDHC-Speicherkarte-32-GB-98-MB-s-Class-10-%2F232765345038)\* SD-Karte von SANDISK (weniger als 10€) entschieden, da hier 10 Jahre [Garantie](https://www.sandisk.de/about/legal/warranty/warranty-table) gegeben werden. Also Rechnung gut aufheben. **Und regelmäßig eine [Sicherung](./backup.md) durchführen!**

<img src="https://www.sandisk.de/content/dam/sandisk-main/en_us/portal-assets/product-images/retail-products/Ultra_microSDHC_UHS-I_Class10_32GB-retina.png" width="100">

In diesem [Artikel](https://buyzero.de/blogs/news/raspberry-pi-sd-karten-korruption-vermeiden-geheimnisse-der-microsd-karte) sind SD-Karten in Raspberry Pis ganz gut beschrieben. Da steht auch, was man machen könnte, um die Lebensdauer der Karten zu erhöhen.










---
\* Wenn Du die Sachen nirgendwo günstiger findest, freue ich mich, wenn Du die o.a. Links zum Kauf nutzt. Bin mal gespannt, ob das überhaupt jemand findet und/oder nutzt...
