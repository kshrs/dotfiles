HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000

# PROMPT="%F{green}[%f%F{blue}%n%f%F{red}@%f%F{blue}%m%f%F{green}]%f %F{green}%B%~%b%f %F{yellow}$:%f "
PROMPT="%F{green}%B%~%b%f %F{yellow}$%f "

setopt hist_ignore_all_dups
setopt share_history
setopt autocd

source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
source ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

source <(fzf --zsh)

export FZF_DEFAULT_COMMAND="rg --files --hidden -g '!.git'"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

alias ls='ls --color=auto'
alias ll='ls -lah'
alias zed='zeditor'
alias nv='nvim'
alias vim='nvim'
alias fnv='nvim $(fzf)'

alias spy='source ~/venv/bin/activate'

export PATH=$(go env GOPATH)/bin:$PATH
export JAVA_HOME=/home/kishor/.local/jdk-25.0.1+8
export PATH=/home/kishor/.local/bin:$PATH
export PATH=/home/kishor/.local/jdk-25.0.1+8/bin:$PATH
export PATH=/home/kishor/.local/gradle-9.3.0/bin:$PATH
export QT_QPA_PLATFORMTHEME=qt5ct

export ANTHROPIC_API_KEY=ollama
export ANTHROPIC_BASE_URL=http://localhost:11434
export ANTHROPIC_DEFAULT_OPUS_MODEL="qwen2.5-coder:3b"
export ANTHROPIC_DEFAULT_SONNET_MODEL="qwen2.5-coder:3b"
export ANTHROPIC_DEFAULT_HAIKU_MODEL="qwen2.5-coder:3b"
export CLAUDE_CODE_ATTRIBUTION_HEADER="0"
# eval "$(starship init zsh)"
eval "$(zoxide init zsh)"

