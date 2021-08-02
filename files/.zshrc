# The following lines were added by compinstall

zstyle ':completion:*' completer _complete _ignored
zstyle :compinstall filename "~/.zshrc"
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}

autoload -Uz compinit
compinit
HISTFILE=~/.histfile
HISTSIZE=50000
SAVEHIST=50000
EDITOR=nvim
bindkey -e
bindkey "^[[3~" delete-char

source ~/.config/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh

# NPM packages in homedir
NPM_PACKAGES="$HOME/.npm-packages"
export PATH="$PATH:$HOME/bin:$HOME/.cargo/bin:$HOME/.local/bin:$HOME/go/bin:$HOME/.local/bin:$HOME/workspace/dotfiles/:$NPM_PACKAGES/bin:/usr/local/opt/llvm/bin:$HOME/workspace/ktest"
export PS1="%n %~> "
test -f $HOME/.env && . $HOME/.env
test "${$(which sudo)#*no blw in}" && alias sudo='doas '
case "$(uname -s)" in
    Linux*) alias ls='ls --color';;
    Darwin*) alias ls='ls -G';;
    *) echo "OS customization not supported"; ;
esac

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

# Tell Node about these packages
NODE_PATH="$NPM_PACKAGES/lib/node_modules:$NODE_PATH"
