#!/bin/bash


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
repo_path="/home/docgwiz/gitrepos/trixiedust/"
backup_path="/home/docgwiz/Backups/trixiedust/$TIMESTAMP/"

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

confirm_go () {
	read -p "Do you want to proceed? (Y/n) " doublecheck 
	# Default answer is YES; must press "N" or "n", or script aborts
	if [[ $doublecheck == "n" || $doublecheck == "N" ]]; then
		echo -e "\nAborted.\n"
		exit 0
	fi
}

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
echo -e "lshw -class (M)emory"
echo -e "lshw -class (D)isk"
echo -e "lshw -class (S)torage"
echo -e "lshw -class (N)etwork"
echo -e "lshw -class (G)raphic cards & monitors"
echo -e "lshw -class (M)otherboard"

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
