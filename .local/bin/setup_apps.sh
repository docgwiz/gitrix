#!/bin/bash

# location: ~/.local/bin/<filename>

# See manual:
# https://manpages.debian.org/trixie/rsync/rsync.1.en.html

# Source path WITH a trailing slash (/): 
# This tells rsync to copy the contents of the source directory. 
# The files and subdirectories within the source are copied directly
# into the destination directory.

# Source path WITHOUT a trailing slash: 
# This tells rsync to copy the source directory itself 
# into the destination. 
# An extra directory level with the source directory's name 
# is created inside the destination.

# Always use absolute paths (paths starting with /) in scripts
# to ensure the command behaves consistently 
# regardless of the current working directory (CWD)
# where the script is executed. 
# The shell expands relative paths based on 
# the CWD before rsync runs.

# ================
# DEFINE VARIABLES
# ===============

# -------------------------
# SET GITRIX REPO VARIABLES

REPO_PARENT="$HOME"
REPO_FNAME="gitrix"
REPO_DIR="$REPO_PARENT/$REPO_FNAME"


# ================
# DEFINE FUNCTIONS
# ================

# --------------------------
# FUNCTION: GET CONFIRMATION
confirm_go () {
	local goodtogo
	read -p "Do you want to proceed? (Y/n) " goodtogo 
	if [[ "$goodtogo" == [nN] ]]; then
		echo -e "\nSkipping ...\n"
		return 1
	else
		echo -e "\n"
		return 0
	fi
}


# ------------------------
# FUNCTION: ERROR HANDLING

handle_error() {
	local returned=$?
	echo -e "\nERROR!!! An error occurred on line ${BASH_LINENO[0]} while executing ${BASH_COMMAND}\n" 
	read -p "Continue with apps setup? (Y/n)" choice
	case $choice in
		[Nn])
			echo -e "\nExiting apps setup.\n\n"
			exit "${returned}";;
		*)
			echo -e "\nContinuing ...";;
	esac
}

# Set a trap to call the handle_error function upon any error (ERR)
trap 'handle_error $LINENO' ERR



# ======
# SCRIPT
# ======

# ---------------
# UPDATE PACKAGES

echo -e "\n\nScript will update packages ..."
if confirm_go; then
	sudo apt update
else
	echo -e "Update cancelled. Script file terminated.\n"
	exit 0
fi


# -----------------------------
# INSTALL 1PASSWWORD

echo -e "\n\nScript will install 1Password app ..."
if confirm_go; then 
#	sudo apt install curl wget rsync
#	sudo apt install zip unzip
fi


# -----------------------------
# INSTALL THUNAR

echo -e "\n\nScript will install Thunar file manager ..."
if confirm_go; then
	sudo apt install thunar thunar-volman thunar-archive-plugin   
fi


# -----------------------------
# INSTALL OBSIDIAN



# -----------------------------
# INSTALL CHATGPT

echo -e "\n\nScript will install ChatGPT ..."
echo -e "\nATTENTION! Download ChatGPT's .deb file before continuing!\n\n"
if confirm_go; then
		cd ~/Downloads
		sudo apt install ./chatgpt_amd64.deb;;
fi


# -----------------------------
# INSTALL PROTON APPS

#proton-mail (also calendar)
#proton pass
#proton vpn

echo -e "\n\nScript will install Proton apps ..."
if confirm_go; then 
	sudo apt install curl wget rsync
	sudo apt install zip unzip
fi


# -----------------------------------
# INSTALL THUNDERBIRD

echo -e "\n\nScript will install Thunderbird app ..."
if confirm_go; then
	sudo apt install network-manager
  sudo apt install wavemon
fi



# ----
# EXIT

echo -e "\n\nFINISHED! Apps setup script completed\n\n"
exit 0
