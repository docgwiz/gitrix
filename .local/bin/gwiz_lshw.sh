#!/bin/bash

echo -e "\n\nLIST HARDWARE (lshw)"
echo -e "\nWhat would you like to do?\n"
echo -e "lshw -class (P)rocessor"
echo -e "lshw -class (M)emory"
echo -e "lshw -class (D)isk"
echo -e "lshw -class (S)torage"
echo -e "lshw -class (N)etwork"
echo -e "lshw -class (G)raphics cards & monitors"
echo -e "lshw -class (M)otherboard"
echo -e "lshw -Short (A)ll"
echo -e "\n"

read lshw_choice

case $lshw_choice in 
	"P" | "p") sudo lshw -class processor;;
	"M" | "m") sudo lshw -class memory;;
	"D" | "d") sudo lshw -class disk;;
	"S" | "s") sudo lshw -class storage;;
	"N" | "n") sudo lshw -class network;;
	"G" | "g") sudo lshw -class display;;
	"M" | "m") sudo lshw -class system;;
	"A" | "a") sudo lshw -short;;
	*) sudo lshw -short;;
esac
