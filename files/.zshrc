# The following lines were added by compinstall

zstyle ':completion:*' completer _complete _ignored
zstyle :compinstall filename "~/.zshrc"
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}

autoload -Uz compinit
compinit
HISTFILE=~/.histfile
HISTSIZE=50000
SAVEHIST=50000
export EDITOR=nvim
export DEBEMAIL="brett.holman@canonical.com"
export DEBFULLNAME="Brett Holman"
bindkey -e
bindkey "^[[3~" delete-char

source ~/.config/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh

# NPM packages in homedir
NPM_PACKAGES="$HOME/.npm-packages"
export PATH="$PATH:$HOME/bin:$HOME/.cargo/bin:$HOME/.local/bin:$HOME/go/bin:$HOME/.local/bin:$HOME/workspace/dotfiles/:$NPM_PACKAGES/bin:/usr/local/opt/llvm/bin:$HOME/workspace/ktest:$HOME/workspace/uss-tableflip/scripts"
export PROMPT='%F{240}%n%F{red}@%F{green}%m:%B%~%b %(!.#.>) '
test -f $HOME/.env && . $HOME/.env
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
alias pytest=pytest-3
alias python=python3

# Tell Node about these packages
NODE_PATH="$NPM_PACKAGES/lib/node_modules:$NODE_PATH"

# fuzzy search history, run command (dedupe whitespace)
func zhist() {
	$(sed 's/[[:blank:]]{2}+/ /g' ~/.histfile | uniq | fzf --tac)
}

# fuzzy kill
func zkill(){
	kill $(ps aux  | fzf | awk '{print $2}')
}

# fuzzy find file to open in nvim and update history
func znvim() {
	FZF_FILE="$(fzf)"
	nvim "$FZF_FILE"
	fc -W
	echo "nvim $FZF_FILE" >> $HISTFILE
	fc -R
}
