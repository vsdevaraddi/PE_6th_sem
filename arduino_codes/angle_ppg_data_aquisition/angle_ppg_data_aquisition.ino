/*
This code is written by refering MIT licensed SparkFun Electronics and protocentral's codes 

Harware
One AFE4490
One LSM6DS3

Hardware connections:
-Connect I2C SDA line to A4
-Connect I2C SCL line to A5
-Connect GND and ***3.3v*** power to the IMU.  The sensors are not 5v tolerant.
-attach AFE4490 shield to arduino board.


Address selection:
IMU's address is 0x6B(This is by default)

This program is written to read a IMU(LSM6DS3) and PPG signals from AFE4490. The data sent to serial monitor.

This code is writteb by Veerendra S Devaraddi

Result:
This code is heavy for Arduino Uno R3, so it may not provide data with required rate.
*/



#include <SPI.h>
#include "Protocentral_AFE4490_Oximeter.h"
#include "SparkFunLSM6DS3.h"
#include "Wire.h"

const int SPISTE = 7; // chip select
const int SPIDRDY = 2; // data ready pin
const int RESET =5; // data ready pin
const int PWDN =4; // data ready pin

int datalen = 10;

AFE4490 afe4490;

LSM6DS3 myIMU; //Default constructor is I2C, addr 0x6B
float prev_angle = 0;
float delta_t = 1000/32.0; //1/fs*1000ms 
float alpha_accel = 0.5;//
float alpha_gyro = 1 - alpha_accel;//complimentary
word id = 0;

void setup()
{
  Serial.begin(57600);
  Serial.println("Intilazition AFE44xx.. ");
  delay(2000) ;   // pause for a moment

  SPI.begin();
  // set the directions
  pinMode (SPISTE,OUTPUT);//Slave Select
  pinMode (SPIDRDY,INPUT);// data ready
  attachInterrupt(0, afe44xx_drdy_event, RISING ); // Digital2 is attached to Data ready pin of AFE is interrupt0 in ARduino
  
  myIMU.begin();
  
  // set SPI transmission
  SPI.setClockDivider (SPI_CLOCK_DIV8); // set Speed as 2MHz , 16MHz/ClockDiv
  SPI.setDataMode (SPI_MODE0);          //Set SPI mode as 0
  SPI.setBitOrder (MSBFIRST);           //MSB first

  afe4490.afe44xxInit (SPISTE);
  Serial.println("intilazition is done");
  Serial.println("time(ms),ppg");
}

void loop()
{
  afe44xx_output_values afe4490Data;
  boolean sampled_value = afe4490.getDataIfAvailable(&afe4490Data,SPISTE);

  if (afe4490Data.calculated_value == true)
  { Serial.print(millis());
    Serial.print(",");
    Serial.print(afe4490Data.red);
    //Serial.println(afe4490Data.ir);
    float angle_accel = 57.295*atan2(-1*myIMU.readFloatAccelY(),myIMU.readFloatAccelZ());
    float angle_gyro = prev_angle + myIMU.readFloatGyroX()*delta_t/1000;
    float angle = alpha_accel*angle_accel + alpha_gyro*angle_gyro;
    prev_angle = angle;
    Serial.print(",");
    Serial.println(angle);
    delay(delta_t);
  }
}
