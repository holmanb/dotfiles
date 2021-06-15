# The following lines were added by compinstall

zstyle ':completion:*' completer _complete _ignored
zstyle :compinstall filename "~/.zshrc"

autoload -Uz compinit
compinit
# End of lines added by compinstall
# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=50000
SAVEHIST=50000
bindkey -e
# End of lines configured by zsh-newuser-install
#
export PATH=$PATH:~/bin:~/.cargo/bin:~/.local/bin:~/go/bin:~/workspace/dotfiles/
export PS1="%n %~> "
alias sudo=doas
#zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
alias ls='ls --color'


# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
	test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
	alias ls='ls --color=auto'
	alias dir='dir --color=auto'
	alias vdir='vdir --color=auto'
	alias grep='grep --color=auto'
	alias fgrep='fgrep --color=auto'
	alias egrep='egrep --color=auto'
fi

# NPM packages in homedir
NPM_PACKAGES="$HOME/.npm-packages"

# Tell our environment about user-installed node tools
PATH="$NPM_PACKAGES/bin:$PATH"

# Unset manpath so we can inherit from /etc/manpath via the `manpath` command
unset MANPATH
MANPATH="$NPM_PACKAGES/share/man:$(manpath)"

# Tell Node about these packages
NODE_PATH="$NPM_PACKAGES/lib/node_modules:$NODE_PATH"
