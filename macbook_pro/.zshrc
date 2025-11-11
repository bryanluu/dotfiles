# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="agnoster"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder
export ZSH_CUSTOM="$ZSH/custom"


# Download Znap, if it's not there yet.
[[ -r "$ZSH_CUSTOM/plugins/znap/znap.zsh" ]] ||
    git clone --depth 1 -- \
        https://github.com/marlonrichert/zsh-snap.git "$ZSH_CUSTOM/plugins/znap"
source "$ZSH_CUSTOM/plugins/znap/znap.zsh"  # Start Znap
zstyle ':znap:*' repos-dir "$ZSH_CUSTOM/plugins"

# choose a pretty color for ZSH suggestions
export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=4"

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
  git
  asdf
  zsh-autosuggestions
  zsh-syntax-highlighting
  python
)

source $ZSH/oh-my-zsh.sh

# ZSH autocompletions
znap source marlonrichert/zsh-autocomplete

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
else
  export EDITOR='nvim'
fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# Refresh terminal
alias refresh=". ~/.zshrc"

# Start clj with default repl
alias clj-repl="clojure -M:repl/rebel:inspect/portal-cli"

# Work folders
export SCHOOL_FOLDER="$HOME/Library/CloudStorage/GoogleDrive-loc.bryan.luu@gmail.com/My Drive/Academic/Formal Education/BCIT/Sustainable Business Leadership - Advanced Certificate"
export WORK_FOLDER="$HOME/Work/OPEN-Technologies"
# alias work="cd $WORK_FOLDER"
alias grid="cd $HOME/Work/OPEN-Technologies/GRID/grid"
alias vegh="cd $HOME/Work/OPEN-Technologies/VEGH/vegh-saskatoon-skeleton/"
alias wnm="cd $HOME/Work/OPEN-Technologies/GRID/weather_normalization_model"

# OPEN Technologies shortcuts
function work
{
    echo "Starting work..."
    cd $WORK_FOLDER
    code
    # start up Google Work profile
    open -a "Google Chrome" --args --profile-directory="Profile 4"
    # tmux new -s work
    return 0
}

# Shell Integration
# see https://iterm2.com/documentation-shell-integration.html
# export ITERM2_SQUELCH_MARK=1
# export PS1="%{$(iterm2_prompt_mark)%}$PS1"
test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

# Set default config directory
export XDG_CONFIG_HOME="$HOME/.config"

# Add pg_config from PostgreSQL.app
export PATH="/Applications/Postgres.app/Contents/Versions/latest/bin:$PATH"

# Add .local
export PATH=~/.local/bin:$PATH

# Hook up direnv, see https://direnv.net/docs/hook.html
eval "$(direnv hook zsh)"

source "${XDG_CONFIG_HOME:-$HOME/.config}/asdf-direnv/zshrc"
eval $(thefuck --alias)

# Created by `userpath` on 2024-01-25 00:35:59
export PATH="$PATH:/Users/bluu/Library/Application Support/hatch/pythons/3.9/python/bin"

# Add Go to PATH
export PATH="$PATH:/usr/local/go/bin:$HOME/go/bin"

# Added by LM Studio CLI (lms)
export PATH="$PATH:/Users/bluu/.lmstudio/bin"
# End of LM Studio CLI section

