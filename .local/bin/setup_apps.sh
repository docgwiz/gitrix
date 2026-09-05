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
# DEFINE FUNCTIONS
# ================

# --------------------------
# GET CONFIRMATION

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
# ERROR HANDLING

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


# ------------------------------------------------------------
# DOWNLOAD FILES

download_file() {
    local url="$1"
    local filename="$2"

    echo -e "\n\nDownloading $filename from $url\n"

    curl \
        --fail \
        --location \
        --progress-bar \
        --output "$DOWNLOAD_DIR/$filename" \
        "$url"

    echo "\nDownloaded $DOWNLOAD_DIR/$filename\n"
}


# ---------------------------------------------
# DOWNLOAD PROTON MAIL
#
# Proton publishes the current Linux DEB through its download
# infrastructure. We obtain the current download URL from
# Proton's download page rather than hard-coding a version.

download_proton_mail() {

    echo
    echo "----------------------------------------------"
    echo " Proton Mail Desktop"
    echo "----------------------------------------------"

    local page
    local url
    local filename

    page="$(curl --fail --location --silent \
        'https://proton.me/mail/download')"

    # Look for the Linux DEB download.
    url="$(
        printf '%s\n' "$page" |
        grep -oE 'https?[^"]+\.deb[^"]*' |
        grep -i 'proton' |
        head -n 1 ||
        true
    )"

    if [[ -z "$url" ]]; then
        echo "ERROR: Could not find the Proton Mail DEB download URL."
        echo
        echo "Proton may have changed its download page."
        return 1
    fi

    filename="$(basename "${url%%\?*}")"

    download_file "$url" "$filename"
}


# ------------------------------------------------------------
# DOWNLOAD 1PASSWORD
#
# The official 1Password Linux download page provides the
# Debian/Ubuntu .deb package.
#
# We deliberately download the .deb rather than configuring
# the repository or installing anything.

download_1password() {

    echo
    echo "----------------------------------------------"
    echo " 1Password"
    echo "----------------------------------------------"

    local page
    local url
    local filename

    page="$(
        curl --fail --location --silent \
        'https://1password.com/downloads/linux'
    )"

    url="$(
        printf '%s\n' "$page" |
        grep -oE 'https?[^"]+\.deb[^"]*' |
        head -n 1 ||
        true
    )"

    if [[ -z "$url" ]]; then
        echo "ERROR: Could not find the 1Password DEB download URL."
        echo
        echo "1Password may have changed its download page."
        return 1
    fi

    filename="$(basename "${url%%\?*}")"

    download_file "$url" "$filename"
}


# ------------------------------------------------------------
# DOWNLOAD OBSIDIAN
#
# Obsidian publishes its official releases through:
#
#   github.com/obsidianmd/obsidian-releases
#
# We query the GitHub API for the latest release and select
# the Debian package from its assets.

download_obsidian() {

    echo
    echo "----------------------------------------------"
    echo " Obsidian"
    echo "----------------------------------------------"

    local api
    local url
    local filename

    api="$(
        curl --fail --location --silent \
        'https://api.github.com/repos/obsidianmd/obsidian-releases/releases/latest'
    )"

    url="$(
        printf '%s\n' "$api" |
        grep -oE '"browser_download_url": "[^"]+\.deb"' |
        sed -E 's/^"browser_download_url": "([^"]+)".*$/\1/' |
        head -n 1 ||
        true
    )"

    if [[ -z "$url" ]]; then
        echo "ERROR: Could not find the Obsidian DEB download URL."
        return 1
    fi

    filename="$(basename "${url%%\?*}")"

    download_file "$url" "$filename"
}


# =============================
# MAIN
# =============================

# ------------------------
# ENABLE PIPEFAIL

# When pipefail is enabled, the pipeline's exit status becomes the exit status of the last command to exit with a non-zero status (or zero if all commands succeed).  This ensures that errors in any part of the pipeline are properly propagated, allowing scripts using set -e to detect and handle failures accurately. 

set -euo pipefail


# ---------------
# UPDATE PACKAGES

echo -e "\n\nScript will update packages ..."
if confirm_go; then
	sudo apt update
else
	echo -e "Update cancelled. Script file terminated.\n"
	exit 0
fi


# ---------------------------------------
# SET DOWNLOAD DIRECTORY FOR DEB PACKAGES

DOWNLOAD_DIR="${HOME}/Downloads/debs"

if [ -d "$DOWNLOAD_DIR" ]; then
  echo -e "\n\n$DOWNLOAD_DIR exists.\nDownloading ...\n\n"
else
  echo -e "\n\nCreating $DOWNLOAD_DIR ...\n"
	mkdir -p "$DOWNLOAD_DIR"
  echo -e "\n\nDownloading ...\n\n"
fi   


# ----------------------------
# DOWNLOAD LATEST DEB PACKAGES

# Check required commands
for command in curl grep sed sort; do
    if ! command -v "$command" >/dev/null 2>&1; then
        echo "ERROR: '$command' is required but was not found."
        exit 1
    fi
done

FAILED=0

download_proton_mail || FAILED=1
download_1password || FAILED=1
download_obsidian || FAILED=1


# ------------------
# WRAP UP DOWNLOADS

echo "=============================================="
echo " Download complete"
echo "=============================================="
echo
echo "Files in $DOWNLOAD_DIR"
echo

ls -lh "$DOWNLOAD_DIR"

echo

if [[ "$FAILED" -ne 0 ]]; then
    echo "WARNING: One or more downloads failed!"
    exit 1
fi

echo -e "\nAll downloads completed successfully!\nNow installing packages ..."


# -----------------------------
# INSTALL 1PASSWWORD

echo -e "\n\nScript will install 1Password app ..."
#if confirm_go; then 
	# sudo apt install $DOWNLOAD_DIR/1password-latest.deb
#fi


# -----------------------------
# INSTALL OBSIDIAN



# -----------------------------
# INSTALL PROTON APPS



# -----------------------------
# INSTALL CHATGPT



# -----------------------------
# INSTALL THUNAR

echo -e "\n\nScript will install Thunar file manager ..."
if confirm_go; then
	sudo apt install thunar thunar-volman thunar-archive-plugin   
fi


# -----------------------------------
# INSTALL THUNDERBIRD

echo -e "\n\nScript will install Thunderbird app ..."


# ----------------------------------
# EXIT

echo -e "\n\nFINISHED! Apps setup script completed\n\n"
exit 0

