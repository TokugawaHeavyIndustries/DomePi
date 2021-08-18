#!/bin/bash

while :
do
echo 1 | sudo tee /sys/class/leds/led0/brightness
sleep .5
echo 1 | sudo tee /sys/class/leds/led0/brightness
echo 0 | sudo tee /sys/class/leds/led0/brightness
sleep 1
done
