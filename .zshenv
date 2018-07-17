if yarn -v &>/dev/null; then
    export PATH="$(yarn global bin):$PATH"
fi
if [ -d "$HOME/bin" ]; then
    export PATH="$HOME/bin:$PATH"
fi