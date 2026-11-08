#!/bin/bash
set -euo pipefail

case "${1:-}" in
  work|personal) profile=$1 ;;
  *) echo "用法: $0 {work|personal}" >&2; exit 2 ;;
esac

if [[ $(uname -s) != Darwin || $(uname -m) != arm64 ]]; then
  echo "请在 Apple Silicon Mac 的原生终端中运行。" >&2
  exit 1
fi

cd -- "$(dirname -- "${BASH_SOURCE[0]}")"

nix_profile=/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
if ! command -v nix >/dev/null && [[ ! -r $nix_profile ]]; then
  installer=$(mktemp)
  trap 'rm -f -- "$installer"' EXIT
  curl -fsSL https://install.lix.systems/lix -o "$installer"
  /bin/sh "$installer" install
fi

if ! command -v nix >/dev/null && [[ -r $nix_profile ]]; then
  # Lix 的环境脚本会读取当前 Shell 未定义的变量。
  set +u
  source "$nix_profile"
  set -u
fi

nix_bin=$(command -v nix) || {
  echo "找不到 nix，请检查安装器输出。" >&2
  exit 1
}

sudo "$nix_bin" --extra-experimental-features 'nix-command flakes' \
  run --inputs-from "$PWD" nix-darwin#darwin-rebuild -- \
  switch --flake "$PWD#$profile"
