set fish_greeting

alias cls='clear'
alias del='rm -rf'

alias zsh_config='nvim ~/.zshrc'
alias ghostty_config='nvim ~/.config/ghostty/config'

alias ssh='sshs'
alias sftp='termscp'
alias redis='ratisui'
alias api='atac'
alias sql='lazysql'

zoxide init fish | source
starship init fish | source
