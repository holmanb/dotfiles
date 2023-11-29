# The following lines were added by compinstall

zstyle ':completion:*' completer _complete _ignored
zstyle :compinstall filename "~/.zshrc"
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}

export LANGUAGE="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"
export LC_CTYPE="en_US.UTF-8"

fpath+=~/.zfunc

autoload -Uz compinit && compinit
export HISTFILE=~/.histfile
export HISTSIZE=50000000
export SAVEHIST=50000000
export EDITOR=nvim
export BROWSER=firefox
export PAGER=less
#export MANPAGER='nvim +Man\!'
#export GIT_PROMPT_EXECUTABLE="haskell"
export PROMPT='%B%m%F{green}%~%b%F{reset}$(git_super_status) '
export QT_QPA_PLATFORM=wayland
export MOZ_ENABLE_WAYLAND=1
export WINEPREFIX="$HOME/.wine32"
export WINEARCH=win32
export NPM_PACKAGES="$HOME/.npm-packages"
export PYENV_ROOT="$HOME/workspace/pyenv"
export CC="gcc"
export STANDUP_D="$HOME/Documents/standup/"
export STANDUP_F="$STANDUP_D/standup.txt"

# because debian
export QUILT_PATCHES=debian/patches
export QUILT_REFRESH_ARGS="-p ab --no-timestamps --no-index"
export DEBEMAIL="brett.holman@canonical.com"
export DEBFULLNAME="Brett Holman"

# firefox dev
export PATH="/home/holmanb/.mozbuild/git-cinnabar:$PATH"

bindkey -e
bindkey "^[[3~" delete-char

test -f ~/.zsh && source ~/.config/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
test -f /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh && source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source /home/holmanb/workspace/zsh-git-prompt/zshrc.sh
source /home/holmanb/Documents/creds/novarc

# NPM packages in homedir
export PATH="$PATH:$HOME/bin:$HOME/.cargo/bin:$HOME/.local/bin:$HOME/go/bin:$HOME/.local/bin:$HOME/workspace/dotfiles/:$NPM_PACKAGES/bin:/usr/local/opt/llvm/bin:$HOME/workspace/ktest:$HOME/workspace/uss-tableflip/scripts:$HOME/go/bin:$HOME/workspace/lua-language-server/bin/:$HOME/bin/platform-tools"

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
	alias dmesg='dmesg --color=auto'
	alias htop='htop -s PERCENT_CPU'
fi

# I'm that lazy
#alias pytest=pytest-3
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
	$(sed 's/[[:blank:]]{2}+/ /g' $HISTFILE | sort -u | fzf)
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
			git ls-files -m -o --exclude-standard	\
				| fzf -m --print0		\
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

# Sync notes every day
func standup() {
	cd $STANDUP_D
	git pull
	$EDITOR $STANDUP_F
	git add $STANDUP_F
	git commit -m "automated commit"
	git push
	cd -
}

# cloud init development helpers: re-use stale tox environments for faster iteration
#
# helper lifecycle functions
CI_DIR=$HOME/.cloud-init
ci-setup(){
	git clone https://github.com/canonical/cloud-init.git $CI_DIR
	(
		cd $CI_DIR
		tox -e py3
		tox -e ruff
		tox -e do_format
		tox -e mypy
		CLOUD_INIT_SOURCE="IN_PLACE" tox -e integration-tests -- tests/integration-tests/test_logging.py
	)

}
ci-refresh(){
    (
		cd $CI_DIR
        git pull
		tox -re py3
		tox -re ruff
		tox -re do_format
		tox -re mypy
		CLOUD_INIT_SOURCE="IN_PLACE" tox -e integration-tests -- tests/integration-tests/test_logging.py
    )
}
ci-teardown(){ rm -rf $CI_DIR }

# tox wrappers
ci-py3(){ $CI_DIR/.tox/py3/bin/python -m pytest -vvvv --showlocals ${1-tests/unittests/} }
ci-mypy(){$CI_DIR/.tox/mypy/bin/python -m mypy cloudinit/ tests/ tools/ }
ci-black(){ $CI_DIR/.tox/do_format/bin/python -m black ${1-.} }
ci-isort(){ $CI_DIR/.tox/do_format/bin/python -m isort ${1-.} }
ci-ruff(){ $CI_DIR/.tox/ruff/bin/python -m ruff cloudinit/ tests/ tools/ conftest.py setup.py }
ci-integration(){
	CLOUD_INIT_SOURCE="IN_PLACE" $CI_DIR/.tox/integration-tests/bin/python -m py3 --log-cli-level=INFO ${1-tests/integration_tests/test_logging.py}
}
ci-do_format(){
	ci-isort $@
	ci-black $@
}
ci-py3-fail-fast(){ ci-py3 -x $@ }
ci-all(){
	ci-ruff $@
	ci-py3-fail-fast $@
	ci-do_format $@
	ci-mypy $@
}

alias weather="curl https://v2.wttr.in/"
alias ghettodeb="DEB_BUILD_OPTIONS=nocheck packages/bddeb -d"

#eval "$(pyenv init --path)"
#eval "$(pyenv init -)"

alias luamake=/home/holmanb/workspace/lua-language-server/3rd/luamake/luamake


export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
