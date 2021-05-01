/*
This code is written by refering MIT licensed SparkFun Electronics codes 

Hardware
Two LSM6DS3

Hardware connections
-Connect I2C SDA line to A4
-Connect I2C SCL line to A5
-Connect GND and ***3.3v*** power to the IMU.  The sensors are not 5v tolerant.
-Both the IMUs share the A4 and A5 pin of arduino.

Address selection:
Thoracic node's address is 0x6A(This has to be changed by soldering the address pin to 6A)
Abdominal node's address os 0x6B(This is by default)

This program is written to read two IMUs, and calculate thoracic and abdominal angles. The data sent to serial monitor.

This code is written by Veerendra S Devaraddi
*/
#include "SparkFunLSM6DS3.h"
#include "Wire.h"
#include "SPI.h"

LSM6DS3 thoracic_node(I2C_MODE,0x6A);
LSM6DS3 abdominal_node(I2C_MODE,0x6B);

float delta_t = 1000/401.0;//1000/fs ms
float alpha_accel = 0.5;
float alpha_gyro = 1- alpha_accel;
word id = 0;

struct node{
    float prev_angle = 0;
    float angle_accel;
    float angle_gyro;
    float angle = 0;
  } thoracic_angle,abdominal_angle;
  


void setup() {
  // put your setup code here, to run once:
    Serial.begin(57600);
    delay(1000);
    Serial.println("Serial port is connected");
    if( thoracic_node.begin() != 0){
      Serial.println("Thoracic node is not connected");
    }
    if( abdominal_node.begin() != 0){
      Serial.println("Abdominal node is not connected");
    }
    Serial.println("id,thoracic_angle,abdominal_angle");
}

void loop() {
  thoracic_angle.angle_accel = 57.295*atan2(-1*thoracic_node.readFloatAccelY(),thoracic_node.readFloatAccelZ());
  thoracic_angle.angle_gyro = thoracic_angle.prev_angle + thoracic_node.readFloatGyroX()*delta_t/1000;
  abdominal_angle.angle_accel = 57.295*atan2(-1*abdominal_node.readFloatAccelY(),abdominal_node.readFloatAccelZ());
  abdominal_angle.angle_gyro = abdominal_angle.prev_angle + abdominal_node.readFloatGyroX()*delta_t/1000; 
  thoracic_angle.angle = alpha_accel*thoracic_angle.angle_accel + alpha_gyro*thoracic_angle.angle_gyro;
  thoracic_angle.prev_angle = thoracic_angle.angle;
  abdominal_angle.angle = alpha_accel*abdominal_angle.angle_accel + alpha_gyro*abdominal_angle.angle_gyro;
  abdominal_angle.prev_angle = abdominal_angle.angle;
  Serial.print(millis());
  Serial.print(",");
  Serial.print(thoracic_angle.angle);
  Serial.print(",");
  Serial.println(abdominal_angle.angle);
  id = id+1;
  delay(delta_t);
}
