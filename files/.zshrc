# The following lines were added by compinstall

zstyle ':completion:*' completer _complete _ignored
zstyle :compinstall filename "~/.zshrc"
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}

autoload -Uz compinit
compinit
export HISTFILE=~/.histfile
export HISTSIZE=50000
export SAVEHIST=50000
export EDITOR=nvim
export GIT_PROMPT_EXECUTABLE="haskell"
export DEBEMAIL="brett.holman@canonical.com"
export DEBFULLNAME="Brett Holman"
export PROMPT='%B%m%F{green}%~%b%F{reset}$(git_super_status) '
export QT_QPA_PLATFORM=wayland
export WINEPREFIX="$HOME/.wine32"
export WINEARCH=win32
export NPM_PACKAGES="$HOME/.npm-packages"
export PYENV_ROOT="$HOME/workspace/pyenv"
export CC="ccache gcc"

bindkey -e
bindkey "^[[3~" delete-char

#source ~/.config/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source ~/.config/zsh/zsh-git-prompt/zsh-git-prompt/zshrc.sh

# NPM packages in homedir
export PATH="$PATH:$HOME/bin:$HOME/.cargo/bin:$HOME/.local/bin:$HOME/go/bin:$HOME/.local/bin:$HOME/workspace/dotfiles/:$NPM_PACKAGES/bin:/usr/local/opt/llvm/bin:$HOME/workspace/ktest:$HOME/workspace/uss-tableflip/scripts:$HOME/go/bin"
#:$PYENV_ROOT/bin"

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

# I'm that lazy
alias pytest=pytest-3
alias python=python3
alias flake=flake8

# Tell Node about these packages
NODE_PATH="$NPM_PACKAGES/lib/node_modules:$NODE_PATH"

# log and execute command
# used to log commands interactively built with fzf
func zlog(){
	my_function=$@
	echo "$my_function"
	fc -W
	echo "$my_function" >> $HISTFILE
	eval "$my_function"
	fc -R
}

# fuzzy search history, run command (dedupe whitespace)
func zhist() {
	$(sed 's/[[:blank:]]{2}+/ /g' ~/.histfile | uniq | fzf --tac)
}

# fuzzy kill
func zkill(){
	zlog kill "$(ps aux  | fzf | awk '{print $2}')"
}

# fuzzy find file to open in nvim and update history
func znvim() {
	FZF_FILE="$(fzf)" && zlog "$EDITOR $FZF_FILE"
}

# interactively fzf/git operations
func zgit() {
	case "$1" in
		add)
			git ls-files -m -o --exclude-standard \
				| fzf -m --print0             \
				| xargs -0 -o -t git add
			;;
		*)
			echo "Not implemented"
			return 1
			;;
	esac
}

# select which container(s) to run the command against
func zlxc() {
	for LINE in $(lxc ls | grep -v -e '^+-' -e SNAPSHOTS | awk -F '|' '{print $2}'| fzf -m); do
		RC=$(lxc $@ $LINE)
		echo "lxc $@ $LINE returned [$RC]"
	done
}

#eval "$(pyenv init --path)"
#eval "$(pyenv init -)"
