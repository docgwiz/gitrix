#!/bin/bash

# ---------------------
# INSTALL NERDFONT PACKAGES

	FONTS_DIRLOCAL="$HOME/Backups/fonts"
	FONTS_DIRSYNC="$HOME/Backups/sync"

	# echo -e "\nFONTS_DIRLOCAL = $FONTS_DIRLOCAL"
	# echo -e "\nFONTS_DIRSYNC = $FONTS_DIRSYNC"

  if [[ ! -d "$FONTS_DIRLOCAL" ]]; then
		echo -e "\nCreating folder: $FONTS_DIRLOCAL ..."
		mkdir -p "$FONTS_DIRLOCAL"
	fi	

	cd "$FONTS_DIRSYNC"

	for nerdfont in *.zip; do

		folder_name="${nerdfont%.zip}"
		NERD_DIRLOCAL="$FONTS_DIRLOCAL/$folder_name"

		if [[ ! -d "$NERD_DIRLOCAL" ]]; then
			echo -e "\nCreating folder: $NERD_DIRLOCAL ..."	
			mkdir "$NERD_DIRLOCAL"
		fi

		echo -e "\nUnzipping $nerdfont to $NERD_DIRLOCAL ..."
		unzip "$nerdfont" -d "$NERD_DIRLOCAL"

	done

