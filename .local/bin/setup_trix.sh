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


# Set variables
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")


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

	# readarray -d '' FNAMES2_ARRAY < <(find "$SYSFILE_DIR" -maxdepth 1 -type f -printf "%f\\0")

	echo -e "\n\nThese elements were passed to the install function:\n" 
  for fname in "${FNAMES_ARRAY[@]}"; do
		SYSFILE_PATH="$SYSFILE_DIR/$fname"
		SYMFILE_PATH="$SYMFILE_DIR/$fname"
    echo -e "$fname:\n$SYMFILE_PATH points to $SYSFILE_PATH\n"
  done	

	return 0


	for file in "${passed_array[@]}"; do

	
	# Handle existing files/symlinks in the target directory
	# the -e option checks if file exists
	# the -L option checks if file exists and is a symlink
	# Using [[ ... ]] is preferred in Bash over [ ... ] as it is 
	# more robust, although [ -L "$SYMLINK_PATH" ] is also valid 
	# POSIX syntax  
		if [[ -e "$SYMLINK_PATH" || -L "$SYMLINK_PATH" ]]; then
			echo -e "\nFound existing file or symlink: $SYMLINK_PATH."
			echo -e "Backing up item and creating new symlink."
			mv "$SYMLINK_PATH" "${SYMLINK_PATH}.bak"
			echo -e "Backed up existing item to ${SYMLINK_PATH}.bak"
		fi

		#Create the symlink
		# ln -s "$SYSFILE_NAME_PATH" "$SYMLINK_PATH"
		# echo -e "\nCreated symlink: $SYMLINK_PATH -> $SYSFILE_NAME_PATH\n"

	done
}


# ==========================================================


# ---------------
# UPDATE PACKAGES

echo -e "\n\nUpdating packages ..."
if confirm_go; then
	sudo apt update
else
	echo -e "Script file terminated.\n"
	exit 0
fi


# -------------------
# REFRESH GITRIX REPO

REPO_DIR="$HOME"
REPO_FNAME="gitrix"
REPO_PATH="$REPO_DIR/$REPO_FNAME"

echo -e "\n\nSetting up the $REPO_FNAME repo ..."
if [ -d "$REPO_PATH" ]; then
	echo -e "\n$REPO_FNAME repo exists at $REPO_PATH."
	echo -e "\nPulling from GitHub to update ...\n"
	if confirm_go; then
		cd $REPO_PATH
		git pull origin main
	else
		echo -e "Script file terminated.\n"
		exit 0
	fi
else 
	echo -e "\nCloning the $REPO_FNAME repo from GitHub ...\n" 
	if confirm_go; then
		cd $REPO_DIR
		git clone https://github.com/docgwiz/gitrix.git
	else
		echo -e "Script file terminated.\n"
		exit 0
	fi
fi


# ---------------------------------
# INSTALL SHELL SCRIPTS

SCRIPTSYS_DIR="$REPO_PATH/.local/bin"
SCRIPTSYM_DIR="$HOME/.local/bin"

install_sysfiles "$SCRIPTSYS_DIR" "$SCRIPTSYM_DIR"


# ----------------
# INSTALL DOTFILES

DOTSYS_DIR="$REPO_PATH"
DOTSYM_DIR="$HOME"

install_sysfiles "$DOTSYS_DIR" "$DOTSYM_DIR"


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
#rsync_SYSFILE_NAME=(".profile" ".bashrc" ".bash_aliases" ".gitconfig")

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
