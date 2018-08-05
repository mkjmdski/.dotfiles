for bin_path in "$HOME/bin" "$HOME/.local/bin/"; do
    if [ -d "$bin_path" ]; then
        export PATH="$bin_path:$PATH"
    fi
done
if yarn -v &> /dev/null; then
    export PATH="$(yarn global bin):$PATH"
fi