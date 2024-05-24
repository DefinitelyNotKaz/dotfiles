username() {
   echo "%{$FG[013]%}%n%{$reset_color%}"
}

hostname() {
  echo "%{$FG[014]%}%m%{$reset_color%}"
}

arrow() {
  echo "%{$FG[015]%}❯%{$reset_color%}"
}

privilege() {
  local symbol="$"
  if [ "$UID" -eq 0 ]; then
    symbol="#"
  fi

  echo "%{$FG[015]%}${symbol}%{$reset_color%}"
}

path() {
  echo "%{$FG[010]%}%~%{$reset_color%}"
}

git_prompt() {
  if command git rev-parse --is-inside-work-tree > /dev/null 2>&1; then
    local branch="$(command git branch --show-current)"
    local changes="$(command git status --porcelain)"
    if [ -z "$changes" ]; then 
      echo "%{$FG[010]%}${branch}%{$reset_color%}"
    else 
      echo "%{$FG[001]%}*${branch}%{$reset_color%}"
    fi
  else
    echo ""
  fi
}

PROMPT='$(username) $(arrow) $(hostname) $(arrow) $(path)
$(privilege) '

RPROMPT='$(git_prompt)'



