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

# Set TIMESTAMP variable
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")


confirm_go () {
	read -p "Do you want to proceed? (Y/n) " doublecheck 
	if [[ $doublecheck == "n" || $doublecheck == "N" ]]; then
		echo -e "\nSkipping ...\n"
		return 1
	else
		echo -e "\n"
		return 0
	fi
}

# Set up error handling
handle_error() {
	echo -e "\nFAILED!"
	echo -e "An error occurred on line ${BASH_LINENO[0]} while executing ${BASH_COMMAND}\n" 
#	echo >&2
	exit 1
}

# Set a trap to call the handle_error function upon any error (ERR)
trap 'handle_error' ERR


# ---------------
# UPDATE PACKAGES

echo -e "\n\nUpdating packages ..."
sudo apt update




# -----------------
# SETUP GITRIX REPO
#
# cd to $HOME

# if $HOME/gitrix repo doesn't exist, then
	#	prompt to clone gitrix repo from GitHub
	#	clone gitrix repo
# else
	# prompt to pull gitrix repo from GitHub
	# pull gitrix repo
# fi



# ---------------------------------
# CREATE SYMLINKS FOR SHELL SCRIPTS

# Adapt Obsidian note on Dotfile symlinks



# ----------------------------
# CREATE SYMLINKS FOR DOTFILES

# See Obsidian note on Dotfile symlinks



# ----
# EXIT
exit 0




# ---------------------
# RSYNC FLAGS (OPTIONS)
# --mkpath: create all missing destination directories
# --archive -a: archive mode (preserves permissions, timestamps, recursion, etc.)
# --verbose -v: verbose (optional, shows transferred files)
# --update -u: update (skip files that are newer in the destination)
# --existing: only update files that already exist in the destination (optional)
# --delete: delete files in destination not present in source 
# --progress: show progress during transfer
# --human-readable -h: display file sizes easy format for humans
# --dry-run -n: (optional) run a simulation without making any changes


###
### CREATE ARRAYS FOR RSYNC OPTIONS
###
# To pass rsync options using a variable in a Bash script, 
# the recommended method is to use an array. 
# Storing options in a string variable and expanding it in the 
# command can lead to issues with word splitting and quoting, 
# especially with options that contain spaces or special characters 
# (like --exclude '...').

# Array for rsync options
rsync_opts=(--archive --update --delete --verbose --progress --human-readable)

# Array for rsync options + mkpath (used for rsyncing to ~/Backups)
rsync_opts_bku=(--archive --verbose --progress --human-readable --mkpath)

###
### CREATE ARRAYS FOR RSYNC FOLDER/FILE NAMES
###
#rsync_folders=("sway" "waybar" "foot" "mako" "vim" "starship")
#rsync_dotfiles=(".profile" ".bashrc" ".bash_aliases" ".gitconfig")

local_path="/home/docgwiz/"
repo_path="/home/docgwiz/gitrix/"
backup_path="/home/docgwiz/Backups/gitrix/$TIMESTAMP/"

rsync_list[0]=".config/sway/"
rsync_list[1]=".config/waybar/"
rsync_list[2]=".config/foot/"
rsync_list[3]=".config/mako/"
rsync_list[4]=".config/vim/"
rsync_list[5]=".config/wofi/"
rsync_list[6]=".config/starship/"
rsync_list[7]=".profile"
rsync_list[8]=".bashrc"
rsync_list[9]=".bash_aliases"
rsync_list[10]=".gitconfig"
rsync_list[11]=".local/bin/"


rsync_go () {
	echo -e "\nrsync_go ()\n"
}

push_go () {
	echo -e "\npush_go ()\n"
}

pull_go () {
	echo -e "\npull_go ()\n"
}

echo -e "\nWhat would you like to do?\n"
echo -e "Rsync (B)ackup of local setup"
echo -e "Rsync (L)ocal setup to repo"
echo -e "Rysnc (R)epo to local set up"
echo -e "(1) PUSH repo to GitHub"
echo -e "(2) PULL GitHub to repo"

read rsync_choice

case $rsync_choice in 
	"B" | "b")
	# Rsync local Trixie setup to Backup folder
		src_path=$local_path
		dst_path=$backup_path
		opts=("${rsync_opts_bku[@]}")
		;;
	"L" | "l")
	# Rsync local Trixie setup to git repo
		src_path=$local_path
		dst_path=$repo_path
		opts=("${rsync_opts[@]}")
		;;
	"R" | "r")
		# Rsync git repo to local Trixie setup
		src_path=$repo_path
		dst_path=$local_path
		opts=("${rsync_opts[@]}")
		echo -e "\nWARNING! You are about to overwrite your local Trixie setup.\n"
		confirm_go
		;;
	"1")
		push_go
		exit 0
		;;
	"2")
		pull_go
		exit 0
		;;
	*)
		echo -e "\nInvalid option. Aborting ..."
		exit 1
		;;
esac

echo -e "\nRsyncing $src_path to $dst_path ...\n"
echo -e "Rsync OPTIONS: ${opts[@]}\n"

confirm_go

for rsync_item in "${rsync_list[@]}"; do
	echo -e "Rsyncing $src_path$rsync_item to $dst_path$rsync_item\n"
	rsync "${opts[@]}" "$src_path$rsync_item" "$dst_path$rsync_item"
done

echo -e "\nRsync complete."
