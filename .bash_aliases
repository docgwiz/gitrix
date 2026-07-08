# ~/.bash_aliases
# Format: alias <shortcut>='<command to run>'
# Reload this file with source ~/.bash-aliases


# ---------------
# FILE MANAGEMENT
alias qqls='LC_COLLATE=C ls -lah --time-style=long-iso'
alias qqlst='LC_COLLATE=C ls -laht --time-style=long-iso'
# -l: long format (detailed file info)
# -a: all files
# -h: human-readable
# -t: time sort
# -R: recursive (list contents of sub directories)
alias qqrm='gwiz_rm.sh'


# -------------------
# HARDWARE MANAGEMENT
alias qqlshw='gwiz_lshw.sh'
alias qqinxi='gwiz_inxi.sh'
alias qqhw1='inxi -Fxz'
alias qqhw2='sudo hwinfo --short'
alias qqhw3='sudo lshw -short'


# -------------
# APPS/PACKAGES
alias qqvim='sudoedit'
# launches default editor (Vim) with root privileges
# while using regular user editor config files and plugins
alias qqff='fastfetch'


# ---------------
# CLIPBOARD MAGIC
alias qqgat='wl-copy < $HOME/syncthing/.gat'
alias qqgatx='wl-copy < $HOME/.gat'
