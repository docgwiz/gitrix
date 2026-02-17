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


# ---------------------
# INSTALL FONT PACKAGES


# Install nerdfont packages
FONTS_DIRSRC="https://dufs.docgwiz.com/fonts/nerdtest/"
#FONTS_DIRDEST="$HOME/.local/share/fonts/"
FONTS_DIRDEST="$HOME/Backups/"

echo -e "\n\nInstalling nerd font packages ..."
if confirm_go; then 
	
	echo -e "\nNerdFonts will be copied from $FONTS_DIRSRC to $FONTS_DIRDEST"

	echo -e "\nAccessing nerd fonts on https://dufs.docgwiz.com"
	
	wget --no-verbose --recursive \
				--no-parent --no-host-directories --cut-dirs=2 \
				--accept="*.ttf,*.otf" \
				--directory-prefix=$FONTS_DIRDEST \
				--user=docgwiz --ask-password \
				$FONTS_DIRSRC  
 
	if [ $? -eq 0 ]; then
    echo -e "\nWget succeeded"
		echo -e "\nContents of $FONTS_DIRDEST\n"
		ls -la $FONTS_DIRDEST
	else
    echo -e "\nWget failed"
	fi

fi

