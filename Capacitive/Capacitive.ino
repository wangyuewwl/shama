#include <CapacitiveSensor.h>

//CapacitiveSensor cs_4_2 = CapacitiveSensor (4,2);
CapacitiveSensor cs_8_7 = CapacitiveSensor (8,7);

const int ledG = 12;
const int ledY = 11;


int ledValG = 0;
int ledValY = 0;


void setup() {
  // put your setup code here, to run once:
  pinMode(ledG, OUTPUT);
  pinMode(ledY, OUTPUT);
  Serial.begin (9600);
//  cs_4_2.set_CS_AutocaL_Millis(0xFFFFFFFF); 
  cs_8_7.set_CS_AutocaL_Millis(0xFFFFFFFF); 
}

void loop() {
  // put your main code here, to run repeatedly:
  long start = millis();
//  long total1 = cs_4_2.capacitiveSensor(30); 
  long total2 = cs_8_7.capacitiveSensor(30); 

//  Serial.print(total1);
//  Serial.print(",");
  Serial.println(total2);

//  if (total1 > 300) {
//    digitalWrite(ledG, 1);
//    delay(1);
//  } else {
//    digitalWrite(ledG, 0);
//  } 
//  
  if (total2 > 300) {
    digitalWrite(ledY, 1);
    delay(1);
  } else {
      digitalWrite(ledY, 0);
}
}
