# Installing this tool is easy.

Execute following in your terminal.
`temp_dir=$(mktemp -d); gist_url="https://gist.githubusercontent.com/Razz99/3da58eb8f6a3b56ba8a2586152180486/raw/d5e2ad06c8a937c6ac6b53552ef0451d1c57a6a9/gistfile1.txt"; curl -sSL "$gist_url" -o "$temp_dir/script.sh"; chmod +x "$temp_dir/script.sh"; "$temp_dir/script.sh"; rm -r "$temp_dir"`