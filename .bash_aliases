# ~/.bash_aliases
# Format: alias <shortcut>='<command to run>'
# Reload this file with source ~/.bash-aliases

# ------------------
# SYSTEM MAINTENANCE
alias qqupd='sudo apt update'
alias qqupg='sudo apt upgrade'


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
alias qqcurlu='echo "curl -u user:password -T {source file} {url}" && curl -u docgwiz:!ShingleBay2 -T '
# alias qqcurld='curl -u docgwiz:'!ShingleBay2' -o '

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
