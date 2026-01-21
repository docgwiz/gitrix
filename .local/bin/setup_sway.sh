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
	echo -e "\nFAILED!"
	echo -e "An error occurred on line ${BASH_LINENO[0]} while executing ${BASH_COMMAND}\n" 
	exit "${returned}"
}

# Set a trap to call the handle_error function upon any error (ERR)
trap 'handle_error $LINENO' ERR


# ---------------------------
# FUNCTION: INSTALL SYS FILES

install_sysfiles() {
	
# find: get files and store them in the array
# -type f: only matches files (excludes directories)
# -maxdepth 1: limits search to the specified directory
# -printf "%f\\n": prints only the filename without the path, 
#                  followed by a newline
#  printf supports the \0 escape sequence to represent a null characte
# -print0: print the full file name followed by a null character

# readarray: reads lines from input into an array
# -t: removes trailing delimiter (newline by default) from 
#     each line read into the array element
# -d: specifies a delimiter between array elements (e.g. '' aka null) 

	local SYSFILE_DIR="$1" 
	# this is the git repo folder where sys files are located
	local SYMFILE_DIR="$2" 
	# this is the symlink folder where pointers are located

	readarray -t FNAMES_ARRAY < <(find "$SYSFILE_DIR" -maxdepth 1 -type f -printf "%f\\n")

	# readarray -d '' FNAMES_ARRAY < <(find "$SYSFILE_DIR" -maxdepth 1 -type f -printf "%f\\0")

  for fname in "${FNAMES_ARRAY[@]}"; do

		#create symfile directory if it doesn't exist			
		if [[ ! -d "$SYMFILE_DIR" ]]; then
			mkdir -p "$SYMFILE_DIR"
			echo -e "\nCreated $SYMFILE_DIR\n"
		fi

		SYSFILE_PATH="$SYSFILE_DIR/$fname"
		SYMFILE_PATH="$SYMFILE_DIR/$fname"

		# Handle existing symlinks in the SYMFILE directory
		# the -e option checks if file exists
		# the -L option checks if file exists and is a symlink
		# Using [[ ... ]] is preferred in Bash over [ ... ] 
		# as it is more robust
		if [[ -e "$SYMFILE_PATH" || -L "$SYMFILE_PATH" ]]; then
			mv "$SYMFILE_PATH" "${SYMFILE_PATH}.bak"
			echo -e "\nBacked up existing item to ${SYMFILE_PATH}.bak"
		fi

		#Create the symlink
		ln -s "$SYSFILE_PATH" "$SYMFILE_PATH"
		echo -e "\nCreated new symlink: $SYMFILE_PATH"

	done
}


# ======
# SCRIPT
# ======

# ---------------
# UPDATE PACKAGES

echo -e "\n\nUpdating packages ..."
if confirm_go; then
	sudo apt update
else
	echo -e "Script file terminated.\n"
	exit 0
fi

# -----------------
# INSTALL FASTFETCH

echo -e "\n\nInstalling FastFetch ..."
if confirm_go; then 
	sudo apt install fastfetch
fi


# -------------------
# INSTALL FIREFOX-ESR

echo -e "\n\nInstalling Firefox-ESR ..."
if confirm_go; then 
	sudo apt install firefox-esr
fi


# -----------------------------
# INSTALL FILE MANAGEMENT UTILS

echo -e "\n\nInstalling file management utilities ..."
if confirm_go; then 
	sudo apt install curl wget rsync
	sudo apt install zip unzip
fi


# -----------
# INSTALL VIM

echo -e "\n\nInstalling Vim ..."
if confirm_go; then 
	sudo apt install vim
fi


# Create un-synced directory for Vim's 
# swap, backup, and undo files

VIM_NOSYNC="$HOME/.local/tmp/vim/"

echo -e "\nCreating $VIM_NOSYNC for Vim's swap, backup, and undo files ...\n"
if confirm_go; then 
	# -e FILE	Returns true if the file/path exists.
	# -f FILE	Returns true if the file exists and is a regular file.
	# -d FILE	Returns true if the file exists and is a directory.
	if [[ -d "$VIM_NOSYNC" ]]; then	
		echo -e "\n$VIM_NOSYNC exists.\n"
	else	
		mkdir -p $VIM_NOSYNC
		echo -e "\n$VIM_NOSYNC created.\n"
	fi
fi


# Make Vim the default editor
echo -e "\nMaking Vim the default editor ..."
if confirm_go; then 
	sudo update-alternatives --config editor
fi


# ---------------------
# INSTALL FONT PACKAGES

echo -e "\n\nInstalling font packages ..."
if confirm_go; then 
	# Install recommended fonts
	sudo apt install fonts-recommended
	# Install awesome font
	sudo apt install fonts-font-awesome
	
	# Install mono nerd fonts
	FONT_DIRLOCAL="$HOME/.local/share/fonts"
	FONT_DIRREPO="$REPO_DIR/.local/share/fonts"

  if [[ ! -d "$FONT_DIRLOCAL" ]]; then
		mkdir -p "$FONT_DIRLOCAL"
	fi	

	# Use rsync to cp files from gitrix font directory 
	# to local font dir
	#rsync

	# DejaVuSansM Nerd Font
	# Original Font Name: DejaVu Sans Mono
	# Dotted zero, based on the Bitstream Vera Fonts with a wider range of character
	# https://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0/DejaVuSansMono.zip

	# MesloLG Nerd Font
	# Slashed zeros, customized version of Apple's Menlo
	# https://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0/Meslo.zip
	
	# InconsolataGo Nerd Font
	# Slashed zero, takes inspiration from many different fonts and glyphs, subtle curves in lowercase, straight quotes
	# https://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0/InconsolataGo.zip
	
	# FiraMono Nerd Font
	# Original Font Name: Fira
	# Mozilla typeface, dotted zero
	# https://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0/FiraMono.zip
	
	# JetBrainsMono Nerd Font
	# JetBrains officially created font for developers 
	# https://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0/JetBrainsMono.zip
	

	# Rebuild the font cache:
	echo -e "\n\nRebuilding the font cache ..."
	fc-cache -f
	# -f: Forces regeneration, even if cache seems up-to-date
	# -v: Shows verbose output (status information)		
	# -s: Scans only system-wide directories, skips user-specific dirs
	echo -e "Rebuild complete.\n"

fi


# ------------
# INSTALL SWAY

echo -e "\n\nInstalling Sway Window Manager ..."
if confirm_go; then 
	sudo apt install sway
	# This will automatically install dependencies, including
	# - swagbg (aka swaybackgrounds)
	# - wmenu
	# - foot 
	# - sgml-base (likely installed earlier by polkitd)
	# - xml-core (likely installed earlier by polkitd)
fi


# -------------------------------------
# INSTALL RECOMMENDED PACKAGES FOR SWAY

echo -e "\n\nInstalling recommended packages for Sway WM ..."
if confirm_go; then 
	# Install recommended packages:
	sudo apt install swaylock swayidle sway-backgrounds

	sudo apt install foot-themes

	sudo apt install debhelper 
	# debian helper installs build-essential, make, et al

	sudo apt install xdg-desktop-portal 
	# xdg-desktop-portal installs fuse3, x11-common, et al) 
	# AND RECOMMENDS gvfs 

	sudo apt install xdg-desktop-portal-wlr 
# xdg...wlr installs pipewire, pipewire-pulse, wireplumber, slurp et al

	sudo apt install xdg-desktop-portal-gtk

	sudo apt install xdg-utils 

	sudo apt install lm-sensors sgml-base-doc 
	
	sudo apt install liblcms2-utils libwacom-bin

fi


# ----------------
# INSTALL XWAYLAND
echo -e "\n\nInstalling Xwayland for packages that need X11 ..."
if confirm_go; then 
	sudo apt install xwayland
fi


# --------------------------
# CREATE AN ENVIRONMENT FILE
# create /etc/environment with root privileges

echo -e "\n\nCreating an environment file ..."
if confirm_go; then 
	ENV_FILE="/etc/environment"

	# -e FILE	Returns true if the file/path exists.
	# -f FILE	Returns true if the file exists and is a regular file.
	# -d FILE	Returns true if the file exists and is a directory.
	if [[ -e "$ENV_FILE" ]]; then
		echo -e "\n$ENV_FILE exists. Skipping ..."
	else
		echo -e "\nCreating $ENV_FILE ...\n"

		# The printf command is more reliable than echo for interpreting
		# escape sequences consistently across various systems. 
		# It does not automatically add a trailing newline, 
		# so you must include \n at the end if desired. 
		printf -v ENV_CONTENT "XDG_CURRENT_DESKTOP=sway\nMOZ_ENABLE_WAYLAND=1\nQT_QPA_PLATFORM=wayland\nCLUTTER_BACKEND=wayland\nSDL_VIDEODRIVER=wayland"
	
		# The tee command is a common and effective way to 
		# redirect output to a root-owned file because tee itself 
		# is executed with sudo privileges. 
		# The > /dev/null part prevents tee from outputting the content 
		# to standard output, keeping your script's output clean. 
		echo "$ENV_CONTENT" | sudo tee -a "$ENV_FILE" > /dev/null

		echo -e "File complete.\n\n$ENV_FILE = \n"
		cat $ENV_FILE
	fi
fi


# --------------
# INSTALL WAYBAR

echo -e "\n\nInstalling Waybar ..."
if confirm_go; then 
	sudo apt install waybar
fi


# ------------------------------
# INSTALL SWAY SUPPORT UTILITIES

echo -e "\n\nInstalling brightnessctl ..."
if confirm_go; then 
	sudo apt install brightnessctl
fi

echo -e "\n\nTweaking brightnessctl!\nAdding $USER to video and input groups ..."
if confirm_go; then 
	sudo usermod -a -G video "$USER"
	sudo usermod -a -G input "$USER"
	groups "$USER"	
fi

echo -e "\n\nInstalling pulseaudio and suggested packages ..."
if confirm_go; then 
	sudo apt install pulseaudio
	sudo apt install pavucontrol
fi


echo -e "\n\nInstalling polkit and MATE policy authentication package ..."
if confirm_go; then
	sudo apt install polkitd			
	sudo apt install mate-polkit
fi

echo -e "\n\nInstalling wl-clipboard ..."
if confirm_go; then 
	sudo apt install wl-clipboard
fi

echo -e "\n\nInstalling clipman ..."
if confirm_go; then
	sudo apt install clipman
fi

echo -e "\n\nInstalling more utilities ..."
if confirm_go; then

	sudo apt install grim slurp
	# tools for screenshots

	sudo apt install hstr
	# see and search bash history
	
	sudo apt install fd-find
	# find files and directories in a filesystem
	
	sudo apt install gawk 
	# filtering, formatting, and transforming data

	sudo apt install htop
 	# text-based system monitor

	sudo apt install gimp
	sudo apt install imagemagick
	# creating, editing, converting, and displaying images
	# gimp supports imagemagick
	
	sudo apt install font-manager
	# preview and manage installed and available fonts
	
fi


# -------------
# INSTALL MAKO

# Mako needs the libnotify package:
echo -e "\n\nInstalling Mako ..."
if confirm_go; then 
	sudo apt install libnotify-bin
	sudo apt install mako-notifier
	notify-send "Mako is running!"
fi


# ------------
# INSTALL WOFI

echo -e "\n\nInstalling Wofi ..."
if confirm_go; then 
	sudo apt install wofi
fi


# ----------------
# INSTALL STARSHIP

echo -e "\n\nInstalling Starship ..."
if confirm_go; then 
	sudo apt install starship
fi


# ---------------------
# INSTALL SHELL SCRIPTS

echo -e "\n\nInstalling scripts ..."
if confirm_go; then 
	SCRIPTSYS_DIR="$REPO_DIR/.local/bin"
	SCRIPTSYM_DIR="$HOME/.local/bin"
	install_sysfiles "$SCRIPTSYS_DIR" "$SCRIPTSYM_DIR"
fi


# ----------------
# INSTALL DOTFILES

echo -e "\n\nInstalling dot files ..."
if confirm_go; then 
	DOTSYS_DIR="$REPO_DIR"
	DOTSYM_DIR="$HOME"
	install_sysfiles "$DOTSYS_DIR" "$DOTSYM_DIR"
fi

# --------------------
# INSTALL CONFIG FILES

SWAY_PACKS=("sway" "starship" "foot" "waybar" "vim" "wofi" "mako")

echo -e "\n\nInstalling config files for Sway packages ..."
if confirm_go; then 
	CONFIG_DIR=".config"
	for PACK_DIR in "${SWAY_PACKS[@]}"; do
		CONFIGSYS_DIR="$REPO_DIR/$CONFIG_DIR/$PACK_DIR"
		CONFIGSYM_DIR="$HOME/$CONFIG_DIR/$PACK_DIR"
		install_sysfiles "$CONFIGSYS_DIR" "$CONFIGSYM_DIR"
	done
fi


# -----------------
# INSTALL SYNCTHING

if confirm_go; then
	sudo apt install syncthing
	systemctl --user enable syncthing.service
	echo -e "\n\nReboot may be required to bring syncthing online\n"
fi



# ----
# EXIT

echo -e "\n\nSWAY SETUP UP SCRIPT COMPLETED\n\n"
exit 0
