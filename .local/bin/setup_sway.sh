#!/bin/bash

# location: ~/.local/bin/<filename>



# -----------
# INSTALL VIM

echo -e "\n\nInstalling Vim ..."
if confirm_go; then 
	sudo apt install vim
fi


# Create un-synced directory for Vim's 
# swap, backup, and undo files

VIM_NOSYNC="$HOME/.local/tmp/vim/"

echo -e "\n\nCreating $VIM_NOSYNC for Vim's swap, backup, and undo files ...\n"
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
echo -e "\n\nMaking Vim the default editor ..."
if confirm_go; then 
	sudo update-alternatives --config editor
fi


# ---------------------
# INSTALL FONT PACKAGES

echo -e "\n\nInstalling fonts ..."
if confirm_go; then 
	# Install recommended fonts
	sudo apt install fonts-recommended
	# Install awesome font
	sudo apt install fonts-font-awesome
	# Install jetbrains font
	sudo apt install fonts-jetbrains-mono
	# Install a Nerd Font
	sudo apt install fonts-firacode
fi

# Rebuild the font cache:
echo -e "\n\nRebuilding the font cache ..."
if confirm_go; then 
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

echo -e "\n\nInstalling suggested packages for Sway WM ..."
if confirm_go; then 
	# Install sway-suggested packages:
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


# -----------------
# INSTALL UTILITIES

echo -e "\n\nAdding $USER to video and input groups ..."
if confirm_go; then 
	sudo usermod -a -G video "$USER"
	sudo usermod -a -G input "$USER"	
fi

echo -e "\n\nInstalling brightnessctl ..."
if confirm_go; then 
	sudo apt install brightnessctl
fi

echo -e "\n\nInstalling pulseaudio ..."
if confirm_go; then 
	sudo apt install pulseaudio
fi

echo -e "\n\nInstalling wl-clipboard ..."
if confirm_go; then 
	sudo apt install wl-clipboard
fi

echo -e "\n\nInstalling MATE policy authentication package ..."
if confirm_go; then
	sudo apt install mate-polkit
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

	sudo apt install imagemagick gimp
	# creating, editing, converting, and displaying images
	# gimp supports imagemagick
	
	sudo apt install font-manager
	# preview and manage installed and available fonts
	
fi


# ----------------
# INSTALL STARSHIP

echo -e "\n\nInstalling Starship ..."
if confirm_go; then 
	sudo apt install starship
fi

# location of Starship config file is set in 
# the bash resource config file (.bashrc)



# -------------
# INSTALL MAKO

# Mako needs the libnotify package:
echo -e "\n\nInstalling Mako ..."
if confirm_go; then 
	sudo apt install libnotify-bin
	sudo apt install mako-notifier
	notify-send "Hello world!" 
fi


# ------------
# INSTALL WOFI

echo -e "\n\nInstalling Wofi ..."
if confirm_go; then 
	sudo apt install wofi
fi


# ----
# EXIT
exit 0
