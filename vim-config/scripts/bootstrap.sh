#!/bin/sh
# Install vim-plug and make this modular configuration the default for Vim.
set -eu
root=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
data=${VIM_CONFIG_DATA:-"$HOME/.local/share/vim-config"}
mkdir -p "$data/autoload"
tmp=
vimrc_tmp=
trap 'if [ -n "$tmp" ]; then rm -f "$tmp"; fi; if [ -n "$vimrc_tmp" ]; then rm -f "$vimrc_tmp"; fi' EXIT HUP INT TERM
if [ -f "$data/autoload/plug.vim" ]; then
        printf '%s\n' "vim-plug already exists: $data/autoload/plug.vim"
else
        tmp=$(mktemp "$data/autoload/plug.vim.XXXXXX")
        printf '%s\n' 'Downloading vim-plug from GitHub (connection timeout: 10s; total limit: 45s)...'
        if ! curl --fail --location --show-error --connect-timeout 10 --max-time 45 --speed-limit 1 --speed-time 15 --proto '=https' --tlsv1.2 https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim -o "$tmp"; then
                printf '%s\n' \
                        'Could not download vim-plug. Your ~/.vimrc and ~/.vimrc.old were not changed.' \
                        'Check access to raw.githubusercontent.com, your VPN/proxy, and DNS, then rerun bootstrap.' >&2
                exit 1
        fi
        if [ ! -s "$tmp" ]; then
                printf '%s\n' 'Downloaded vim-plug is empty; installation stopped. Your vimrc was not changed.' >&2
                exit 1
        fi
        mv "$tmp" "$data/autoload/plug.vim"
        tmp=
fi

# Pin the source directory: copying vimrc alone must not move its module root.
vimrc_tmp=$(mktemp "$HOME/.vimrc.install.XXXXXX")
root_vim=$(printf '%s' "$root" | sed "s/'/''/g")
{
        printf "let g:vim_config_root = '%s'\n" "$root_vim"
        cat "$root/vimrc"
} > "$vimrc_tmp"

# Replace the previous backup only when there is a current vimrc to back up.
# -L also catches a broken symlink; mv preserves symlinks rather than following them.
if [ -e "$HOME/.vimrc" ] || [ -L "$HOME/.vimrc" ]; then
        if [ -d "$HOME/.vimrc" ] || [ -d "$HOME/.vimrc.old" ]; then
                printf '%s\n' 'Refusing to replace a directory at ~/.vimrc or ~/.vimrc.old.' >&2
                exit 1
        fi
        rm -f "$HOME/.vimrc.old"
        mv "$HOME/.vimrc" "$HOME/.vimrc.old"
        printf '%s\n' 'Previous ~/.vimrc moved to ~/.vimrc.old (older backup replaced).'
fi
cp "$vimrc_tmp" "$HOME/.vimrc"
printf '%s\n' 'Vim configuration installed at ~/.vimrc. Open vim and run :PlugInstall.'
