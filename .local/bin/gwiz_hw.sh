#!/bin/bash

echo -e "\n\nSYTEM INFO (sudo hwinfo)"
echo -e "\nWhat would you like to do?\n"
echo -e " 0 sudo hwinfo --all"
echo -e " 1 sudo hwinfo --bios"
echo -e " 2 sudo hwinfo --bluetooth"
echo -e " 3 sudo hwinfo --camera"
echo -e " 4 sudo hwinfo --cdrom"
echo -e " 5 sudo hwinfo --cpu"
echo -e " 6 sudo hwinfo --disk"
echo -e " 7 sudo hwinfo --gfxcard"
echo -e " 8 sudo hwinfo --keyboard"
echo -e " 9 sudo hwinfo --memory"
echo -e " A sudo hwinfo --monitor"
echo -e " B sudo hwinfo --mouse"
echo -e " C sudo hwinfo --network"
echo -e " D sudo hwinfo --pci"
echo -e " E sudo hwinfo --sound"
echo -e " F sudo hwinfo --usb"
echo -e " W sudo hwinfo --wlan"
echo -e " Z sudo hwinfo --short"
echo -e "\n"

read hwinfo_choice

case $hwinfo_choice in
  "0") sudo hwinfo --all;;
	"1") sudo hwinfo --bios;;
	"2") sudo hwinfo --bluetooth;;
	"3") sudo hwinfo --camera;;
	"4") sudo hwinfo --cdrom;;
	"5") sudo hwinfo --cpu;;
	"6") sudo hwinfo --disk;;
	"7") sudo hwinfo --gfxcard;;
	"8") sudo hwinfo --keyboard;;
	"9") sudo hwinfo --memory;;
	"A" | "a") sudo hwinfo --monitor;;
	"B" | "b") sudo hwinfo --mouse;;
	"C" | "c") sudo hwinfo --network;;
	"D" | "d") sudo hwinfo --pci;;
	"E" | "e") sudo hwinfo --sound;;
	"F" | "f") sudo hwinfo --usb;;
	"W" | "w") sudo hwinfo --wlan;;
  "Z" | "z") sudo hwinfo --short;;
	*) sudo hwinfo --short;;
esac
