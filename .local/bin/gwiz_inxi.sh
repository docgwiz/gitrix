#!/bin/bash

echo -e "\n\nSYTEM INFO (inxi)"
echo -e "\nWhat would you like to do?\n"
echo -e " 0 inxi --info"
echo -e " 1 inxi --basic"
echo -e " 2 inxi --system"
echo -e " 3 inxi --machine"
echo -e " 4 inxi --cpu"
echo -e " 5 inxi --memory"
echo -e " 6 inxi --disk"
echo -e " 7 inxi --swap"
echo -e " 8 inxi --graphics"
echo -e " 9 inxi --audio"
echo -e " A inxi --network"
echo -e " B inxi --battery"
echo -e " C inxi --bluetooth"
echo -e " D inxi --ip"
echo -e " E inxi --usb"
echo -e " F inxi --sensors"
echo -e " W inxi --weather"
echo -e "\n"

read inxi_choice

case $inxi_choice in
  "0") inxi --info;;
	"1") inxi --basic;;
	"2") inxi --system;;
	"3") inxi --machine;;
	"4") inxi --cpu;;
	"5") inxi --memory;;
	"6") inxi --disk;;
	"7") inxi --swap;;
	"8") inxi --graphics;;
	"9") inxi --audio;;
	"A" | "a") inxi --network;;
	"B" | "b") inxi --battery;;
	"C" | "c") inxi --bluetooth;;
	"D" | "d") inxi --ip;;
	"E" | "e") inxi --usb;;
	"F" | "f") inxi --sensors;;
	"W" | "w") inxi --weather;;
	*) inxi --basic;;
esac
