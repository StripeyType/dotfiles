function tarbomb(){ [[ $( tar tf "$1" |sed 's,^\./,,' |awk -F/ '{print $1}' |sort |uniq |wc -l ) -eq 1 ]] && echo "OK" || echo 'Tarbomb!'; }


# box() - draw a box
function box(){ t="$1xxxx";c=${2:-=}; echo ${t//?/$c}; echo "$c $1 $c"; echo ${t//?/$c}; } 

# fuck() - kill the fuck out of something. Use like "fuck you firefox" - requires toilet.
function fuck() {
  if killall -9 "$2"; then
    echo ; echo " (╯°□°）╯︵$(echo "$2"|toilet -f term -F rotate)"; echo
  fi
}


### Jump to a direcctory bookmark previously defined with mark()
function jump { 
    cd -P "$MARKPATH/$1" 2>/dev/null || echo "No such mark: $1"
}

### Bookmark the current working directory
function mark { 
    mkdir -p "$MARKPATH"; ln -s "$(pwd)" "$MARKPATH/$1"
}

### Remove a previously-defined directory bookmark
function unmark { 
    rm -i "$MARKPATH/$1"
}

### List all bookmarks
function marks {
    ls -l "$MARKPATH" | sed 's/  / /g' | cut -d' ' -f9- | sed 's/ -/\t-/g' && echo
}

_completemarks() {
  local curw=${COMP_WORDS[COMP_CWORD]}
  local wordlist=$(find $MARKPATH -type l -printf "%f\n")
  COMPREPLY=($(compgen -W '${wordlist[@]}' -- "$curw"))
  return 0
}

complete -F _completemarks jump unmark

### tailc() tails, colors, and intersperses running log files
#   example: tailc 31 /var/log/syslog 32 /var/log/syslog 33 /var/log/nginx/error.log
tailc() (
  while [ "$#" -ge 2 ]; do
    (trap - INT; tail -f -- "$2" | GREP_COLOR=$1 grep --color '.*') &
    shift 2
  done
  wait
)

isintime(){ s=$(date +%s);[ $(date -d "$1" +%s) -lt $s ] && [ $s -lt  $(date -d "$2" +%s) ]; }
