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
	read -p "Continue with Sway setup? (Y/n)" choice
	case $choice in
		[Nn])
			echo -e "\nExiting Sway setup.\n\n"
			exit "${returned}";;
		*)
			echo -e "\nContinuing ...";;
	esac
}

# Set a trap to call the handle_error function upon any error (ERR)
trap 'handle_error $LINENO' ERR


# --------------------------
# FUNCTION: CREATE SYM LINKS

create_symlinks() {
	
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

	local CONFIGREPO_DIR="$1" 
	# this is the git repo folder where Sway config files are located
	local SYMLINK_DIR="$2" 
	# this is a Sway config folder where sym links/pointers are located

	readarray -t FNAMES_ARRAY < <(find "$CONFIGREPO_DIR" -maxdepth 1 -type f -printf "%f\\n")

	# readarray -d '' FNAMES_ARRAY < <(find "$CONFIGREPO_DIR" -maxdepth 1 -type f -printf "%f\\0")

  for fname in "${FNAMES_ARRAY[@]}"; do

		#create symfile directory if it doesn't exist			
		if [[ ! -d "$SYMLINK_DIR" ]]; then
			mkdir -p "$SYMLINK_DIR"
			echo -e "\nCreated $SYMLINK_DIR\n"
		fi

		CONFIGFILE_PATH="$CONFIGREPO_DIR/$fname"
		SYMLINK_PATH="$SYMLINK_DIR/$fname"

		# Handle existing symlinks in the SYMFILE directory
		# the -e option checks if file exists
		# the -L option checks if file exists and is a symlink
		# Using [[ ... ]] is preferred in Bash over [ ... ] 
		# as it is more robust
		if [[ -e "$SYMLINK_PATH" || -L "$SYMLINK_PATH" ]]; then
			mv "$SYMLINK_PATH" "${SYMLINK_PATH}.bak"
			echo -e "\nBacked up existing item to ${SYMLINK_PATH}.bak"
		fi

		#Create the symlink
		ln -s "$CONFIGFILE_PATH" "$SYMLINK_PATH"
		echo -e "\nCreated new symlink: $SYMLINK_PATH"

	done
}


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
# INSTALL FILE MANAGEMENT UTILS

echo -e "\n\nScript will install file management utilities ..."
if confirm_go; then 
	sudo apt install curl -y
	sudo apt install wget -y
	sudo apt install rsync -y
	sudo apt install zip unzip -y
fi


# -----------------------------------
# INSTALL NETWORK MANAGEMENT UTILIIES

echo -e "\n\nScript will install network management utilities ..."
if confirm_go; then
	sudo apt install network-manager network-manager-applet -y
  sudo apt install wavemon -y
fi


# -------------------------------------
# INSTALL HARDWARE MANAGEMENT UTILITIES

echo -e "\n\nScript will install hardware management utilities ..."
if confirm_go; then
	sudo apt install inxi --no-install-recommends
	sudo apt install hwinfo -y
	sudo apt install lshw -y
fi


# -----------------
# INSTALL FASTFETCH

echo -e "\n\nScript will install fastfetch ..."
if confirm_go; then 
	sudo apt install fastfetch -y
fi

 
# ---------------------
# INSTALL BRAVE BROWSER

echo -e "\n\nScript will install brave browser ..."
if confirm_go; then 
	sudo curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg
	sudo curl -fsSLo /etc/apt/sources.list.d/brave-browser-release.sources https://brave-browser-apt-release.s3.brave.com/brave-browser.sources
	sudo apt update
	sudo apt install brave-browser -y
fi


# -------------------
# INSTALL FIREFOX-ESR

echo -e "\n\nScript will install firefox-esr ..."
if confirm_go; then 
	sudo apt install firefox-esr -y
fi


# -----------
# INSTALL VIM

echo -e "\n\nScript will install vim ..."
if confirm_go; then 
	sudo apt install vim -y
fi


# Create un-synced directory for Vim's 
# swap, backup, and undo files

VIM_NOSYNC="$HOME/.local/tmp/vim/"

echo -e "\n\nScript will create $VIM_NOSYNC for Vim's swap, backup, and undo files ...\n"
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
echo -e "\n\nScript will offer default editor selection ..."
if confirm_go; then 
	sudo update-alternatives --config editor
fi


# -----------------
# INSTALL VIFM

echo -e "\n\nScript will install vifm TUI file manager ..."
if confirm_go; then 
	sudo apt install vifm -y
fi


# ---------------------
# INSTALL FONT PACKAGES

# Install apt repo font packages
echo -e "\n\nScript will install apt repository font packages ..."
if confirm_go; then 
	# Install recommended fonts
	sudo apt install fonts-recommended -y
	# Install awesome font
	sudo apt install fonts-font-awesome -y
fi

# Install nerd fonts
echo -e "\n\nScript will install nerd fonts ..."
if confirm_go; then 

	FONT_DIR="${HOME}/.local/share/fonts"
	NFONT_REPO="https://github.com/ryanoasis/nerd-fonts/releases/latest/download"

	mkdir --parents "$FONT_DIR"

	declare -a NFONT_NAME_ARRAY=(
	"0xProto"
	"AtkinsonHyperlegibleMono"
	"DejaVuSansMono"
	"FiraMono"
	"InconsolataGo"
	"JetBrainsMono"
	"Meslo"
	)
	# -a flag declares a variable as an indexed array


	for NFONT_NAME in "${NFONT_NAME_ARRAY[@]}"; do
		NFONT_FNAME="${NFONT_NAME}.zip" 
		NFONT_DIR="${FONT_DIR}/${NFONT_NAME}"
		NFONT_PATH="${NFONT_DIR}/${NFONT_FNAME}"
		NFONT_URL="${NFONT_REPO}/${NFONT_FNAME}"
	
		mkdir --parents "$NFONT_DIR"
		wget --directory-prefix "$NFONT_DIR" "$NFONT_URL"
		unzip "$NFONT_PATH" -d "$NFONT_DIR"
		rm -fv "$NFONT_PATH"
	done   
fi


# Install nerdfont packages
# FONTSRC_DIR="https://dufs.docgwiz.com/fonts/nerdfonts/"
# FONTDEST_DIR="$HOME/.local/share/fonts/"

# echo -e "\n\nScript will install nerd font files ..."
# if confirm_go; then 	
#	  echo -e "\nNerdFonts will be copied from $FONTSRC_DIR to $FONTDEST_DIR"
#	  echo -e "\nAccessing nerd fonts on https://dufs.docgwiz.com"	
#	  wget --no-verbose --recursive --timestamping \
#				--no-parent --no-host-directories --cut-dirs=2 \
#				--accept="*.ttf,*.otf" \
#				--directory-prefix=$FONTDEST_DIR \
#				--user=docgwiz --ask-password \
#				$FONTSRC_DIR  
 
#	  if [ $? -eq 0 ]; then
#     echo -e "\nWget succeeded"
#		  echo -e "\nContents of $FONTDEST_DIR\n"
#		  ls -la $FONTDEST_DIR
#	  else
#     echo -e "\nWget failed"
#	  fi
# fi


# Rebuild the font cache:
echo -e "\n\nScript needs to rebuild the font cache ..."
if confirm_go; then
	fc-cache --force
	# --force: Forces regeneration, even if cache seems up-to-date
	# --system-only: Scans only system-wide directories, skips user-specific dirs
	# --verbose: Shows verbose output (status information)		
	echo -e "Rebuild complete.\n"
fi


# ------------
# INSTALL SWAY

echo -e "\n\nScript will install Sway WM ..."
if confirm_go; then 
	sudo apt install sway -y
	# This will automatically install dependencies, including
	# - swagbg (aka swaybackgrounds)
	# - wmenu
	# - foot 
	# - sgml-base (likely installed earlier by polkitd)
	# - xml-core (likely installed earlier by polkitd)
fi


# -------------------------------------
# INSTALL RECOMMENDED PACKAGES FOR SWAY

echo -e "\n\nScript will install recommended packages for Sway WM ..."
if confirm_go; then 
	# Install recommended packages:
	sudo apt install swaylock swayidle sway-backgrounds -y
	sudo apt install foot-themes -y
	sudo apt install debhelper -y
	# debian helper installs build-essential, make, et al

	sudo apt install xdg-desktop-portal -y
	# xdg-desktop-portal installs fuse3, x11-common, et al) 
	# AND RECOMMENDS gvfs 

	sudo apt install xdg-desktop-portal-wlr -y
# xdg...wlr installs pipewire, pipewire-pulse, wireplumber, slurp et al

	sudo apt install xdg-desktop-portal-gtk -y
	sudo apt install xdg-utils -y
	sudo apt install lm-sensors sgml-base-doc -y
	sudo apt install liblcms2-utils libwacom-bin -y
fi


# ----------------
# INSTALL XWAYLAND
echo -e "\n\nScript will install Xwayland for packages that need X11 ..."
if confirm_go; then 
	sudo apt install xwayland -y
fi


# --------------------------
# CREATE AN ENVIRONMENT FILE
# create /etc/environment with root privileges

echo -e "\n\nScript will create an environment file ..."
if confirm_go; then 
	ENV_FILE="/etc/environment"

	# -e FILE	Returns true if the file/path exists.
	# -f FILE	Returns true if the file exists and is a regular file.
	# -d FILE	Returns true if the file exists and is a directory.
	if [[ -e "$ENV_FILE" ]]; then
		echo -e "\n$ENV_FILE exists. Backing up ..."
		sudo mv "$ENV_FILE" "$ENV_FILE.bak"
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

echo -e "\n\nScript will install Waybar ..."
if confirm_go; then 
	sudo apt install waybar -y
fi


# ------------------------------
# INSTALL SWAY SUPPORT UTILITIES

echo -e "\n\nScript will install brightnessctl ..."
if confirm_go; then 
	sudo apt install brightnessctl -y
fi

echo -e "\n\nTweaking brightnessctl!\nScript will add $USER to video and input groups ..."
if confirm_go; then 
	sudo usermod -a -G video "$USER"
	sudo usermod -a -G input "$USER"
	groups "$USER"	
fi

echo -e "\n\nScript will install pulseaudio and suggested packages ..."
if confirm_go; then 
	sudo apt install pulseaudio -y
	sudo apt install pavucontrol -y
fi

echo -e "\n\nScript will install polkit and MATE policy authentication package ..."
if confirm_go; then
	sudo apt install polkitd -y			
	sudo apt install mate-polkit -y
fi

echo -e "\n\nScript will install wl-clipboard ..."
if confirm_go; then 
	sudo apt install wl-clipboard -y
fi

echo -e "\n\nScript will install clipman ..."
if confirm_go; then
	sudo apt install clipman -y
fi

echo -e "\n\nScript will install more utilities ..."
if confirm_go; then

	sudo apt install dialog -y
	# tui dialog creator for bash

	sudo apt install grim slurp -y
	# tools for screenshots

	sudo apt install hstr -y
	# see and search bash history
	
	sudo apt install fd-find -y
	# find files and directories in a filesystem
	
	sudo apt install gawk -y
	# filtering, formatting, and transforming data

	sudo apt install htop -y
 	# text-based system monitor
	
	echo -e "\n\n"
	sudo apt install gimp -y
	echo -e "\n\n"
	sudo apt install imagemagick -y
	# creating, editing, converting, and displaying images
	# gimp supports imagemagick
	
fi


# -------------
# INSTALL MAKO

# Mako needs the libnotify package:
echo -e "\n\nScript will install mako ..."
if confirm_go; then 
	sudo apt install libnotify-bin -y
	sudo apt install mako-notifier -y
fi


# ------------
# INSTALL WOFI

echo -e "\n\nScript will install wofi ..."
if confirm_go; then 
	sudo apt install wofi -y
fi


# ----------------
# INSTALL STARSHIP

echo -e "\n\nScript will install starship ..."
if confirm_go; then 
	sudo apt install starship -y
fi


# ----------------------------------
# CREATE SYM LINKS FOR SHELL SCRIPTS

echo -e "\n\nScript will create sym links for shell scripts ..."
if confirm_go; then 
	SCRIPTFILE_DIR="$REPO_DIR/.local/bin"
	SYMLINK_DIR="$HOME/.local/bin"
	create_symlinks "$SCRIPTFILE_DIR" "$SYMLINK_DIR"
fi


# -----------------------------
# CREATE SYM LINKS FOR DOTFILES

echo -e "\n\nScript will create sym links for dot files ..."
if confirm_go; then 
	DOTFILE_DIR="$REPO_DIR"
	SYMLINK_DIR="$HOME"
	create_symlinks "$DOTFILE_DIR" "$SYMLINK_DIR"
fi


# -----------------------------------------
# CREATE SYM LINKS FOR PACKAGE CONFIG FILES

SWAY_PACKS=("sway" "starship" "foot" "waybar" "vim" "vifm" "wofi" "mako" "fastfetch")

echo -e "\n\nScript will create sym links for config files ..."
if confirm_go; then 
	CONFIG_DIR=".config"
	for PACK_DIR in "${SWAY_PACKS[@]}"; do
		CONFIGFILE_DIR="$REPO_DIR/$CONFIG_DIR/$PACK_DIR"
		SYMLINK_DIR="$HOME/$CONFIG_DIR/$PACK_DIR"
		create_symlinks "$CONFIGFILE_DIR" "$SYMLINK_DIR"
	done
fi


# -----------------------------
#	INSTALL PACKAGE SUPPORT FILES

# .config/vifm/colors : .vifm files for colorscheme

# .config/vim/autoload : plug.vim
# ~/vim-plugged : location of plugins



# ----
# EXIT

echo -e "\n\n\nFINISHED!\nSway setup script completed\n\n"
exit 0
