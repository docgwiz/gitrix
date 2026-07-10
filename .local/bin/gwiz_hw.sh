#!/bin/bash

dHeight=10
dWidth=40
dChoiceHeight=5
dBackTitle="Shell script dialog box"
dTitle="Run hardware inspection"
dMenu="Choose one of the following options"
choices=(1 "hwinfo" 2 "lshw" 3 "inxi")

run_hwinfo () {
	
	OPTIONS=(
	"bios" ""
	"cpu" ""
	"keyboard" ""
	"disk" ""
	"memory" ""
	"network" ""
	"wlan" ""
	"display" ""
	"monitor" ""
	"gfxcard" ""
	"sound" ""
	"mouse" ""
	"camera" ""
	"bluetooth" ""
	"usb" ""
	"pci" ""
	"cdrom" ""
	"all" ""
	"short" ""
	)
	
	SELECTION=$(dialog --stdout \
		--menu "Choose one:" 27 40 22 \
		"${OPTIONS[@]}" 2>&1)

	clear
	echo -e "\n\nsudo hwinfo --$SELECTION\n"
	sudo hwinfo --$SELECTION
	exit 
}

run_lshw () {
	
	OPTIONS=(
	"processor" ""
	"memory" ""
	"disk" ""
	"storage" ""
	"network" ""
	"display" ""
	"system" ""
	"short" ""
	)
	
	SELECTION=$(dialog --stdout \
		--menu "Choose one:" 15 40 8 \
		"${OPTIONS[@]}" 2>&1)

	clear
	echo -e "\n\nsudo lshw -class $SELECTION\n"
	sudo lshw -class $SELECTION
	exit 
}

run_inxi() {

	OPTIONS=(
	"basic" ""
	"system" ""
	"machine" ""
	"cpu" ""
	"memory" ""
	"disk" ""
	"swap" ""
	"battery" ""	
	"graphics" ""
	"audio" ""
	"network" ""
	"ip" ""
	"usb" ""
	"bluetooth" ""
	"sensors" ""
	"weather" ""
	)
	
	SELECTION=$(dialog --stdout \
		--menu "Choose one:" 23 40 16 \
		"${OPTIONS[@]}" 2>&1)

	clear
	echo -e "\n\ninxi --$SELECTION\n"
	inxi --$SELECTION
	exit 
}

shell_choice=$(dialog --clear \
	--backtitle "$dBackTitle" \
	--title "$dTitle" \
	--menu "$dMenu" $dHeight $dWidth $dChoiceHeight \
	"${choices[@]}" \
	2>&1 >/dev/tty)

clear

case $shell_choice in 
	1) run_hwinfo;;
	2) run_lshw;;
	3) run_inxi;;
esac
