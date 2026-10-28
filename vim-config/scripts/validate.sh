#!/bin/sh
set -eu
root=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
testdir=$(mktemp -d)
trap 'rm -rf "$testdir"' EXIT HUP INT TERM
export VIM_CONFIG_TEST_ROOT="$root" VIM_CONFIG_TEST_STATE="$testdir"
if ! "${VIM:-vim}" -Nu NONE -i NONE -n -es -S "$root/tests/smoke.vim"; then
        [ ! -f "$testdir/validation-errors" ] || cat "$testdir/validation-errors"
        exit 1
fi
printf '%s\n' 'Vim smoke checks passed.'
