#include <Arduino.h>
const int timing = 50;
void setup() {
  pinMode(LED_BUILTIN, OUTPUT);
  Serial.begin(9600);

  while (!Serial) {
    ; // wait for serial port to connect. Needed for native USB.
  }
}

void kurz() {
  Serial.print("kurz ");
  digitalWrite(LED_BUILTIN, HIGH);
  delay(timing);
  digitalWrite(LED_BUILTIN, LOW);
  delay(timing);
}

void lang() {
  Serial.print("lang ");
  digitalWrite(LED_BUILTIN, HIGH);
  delay(3*timing);
  digitalWrite(LED_BUILTIN, LOW);
  delay(3*timing);
}

void pause() {
  Serial.print("   ");
  digitalWrite(LED_BUILTIN, LOW);
  delay(5*timing);
}

void wort_pause() {
  pause();
  pause();
  pause();
  Serial.println(" ");
}

void satz_pause() {
  wort_pause();
  wort_pause();
}

void loop() {
  kurz(); kurz(); kurz(); kurz(); pause();
  lang(); kurz(); pause();
  kurz(); lang(); kurz(); kurz(); pause();
  kurz(); lang(); kurz(); kurz(); pause();
  lang(); lang(); lang();
  wort_pause();
  kurz(); lang(); kurz(); pause();
  kurz(); pause();
  kurz(); lang(); kurz(); pause();
  kurz();
  satz_pause();
}
