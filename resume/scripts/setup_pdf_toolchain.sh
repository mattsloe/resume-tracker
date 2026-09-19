#!/usr/bin/env bash
# Installs the PDF toolchain that build.sh and the layout checks in
# job-application/references/artifacts.md depend on.
#
# Intended for a fresh Linux container (Claude Code on the web, CI, a new VM),
# where none of it is present. Safe to re-run: anything already installed is
# left alone.
set -euo pipefail

# Match the version the committed exports were built with (readable via
# `pdfinfo -meta <pdf>` as the Creator field), so a PDF rebuilt in a hosted
# session matches one rebuilt locally.
TYPST_VERSION="v0.14.2"

fail() {
  printf 'error: %s\n' "$1" >&2
  exit 1
}

note() {
  printf '%s\n' "$1"
}

if [[ "$(uname -s)" != "Linux" ]]; then
  note "This script provisions Linux containers only."
  note "On macOS install the toolchain with Homebrew instead:"
  note "  brew install typst poppler"
  exit 0
fi

# apt needs root; fall back to sudo when this is not already a root shell.
SUDO=""
if [[ "$(id -u)" -ne 0 ]]; then
  command -v sudo >/dev/null 2>&1 || fail "need root or sudo to install packages"
  SUDO="sudo"
fi

# poppler-utils supplies pdfinfo/pdftoppm for the layout checks.
#
# fonts-liberation matters more than it looks: the template font stacks ask for
# Helvetica Neue / Arial / Charter / Times New Roman, none of which exist on
# Linux. Without a fallback installed, Typst warns to stderr, silently
# substitutes a serif face, and still exits 0 -- so the build reports success
# while rendering the resume in the wrong typeface. Liberation Sans and
# Liberation Serif are the metric-compatible stand-ins the templates name last.
#
# Probe for the specific regular face, not the directory. The separate
# fonts-liberation-sans-narrow package installs into the SAME directory, so a
# directory check passes while only the condensed faces are present.
LIBERATION_SANS="/usr/share/fonts/truetype/liberation/LiberationSans-Regular.ttf"

missing_pkgs=()
command -v pdfinfo >/dev/null 2>&1 || missing_pkgs+=(poppler-utils)
[[ -f "$LIBERATION_SANS" ]] || missing_pkgs+=(fonts-liberation)

if [[ ${#missing_pkgs[@]} -gt 0 ]]; then
  note "Installing ${missing_pkgs[*]}..."
  $SUDO apt-get update -qq
  $SUDO apt-get install -y -qq "${missing_pkgs[@]}"
else
  note "poppler-utils and fonts-liberation already present."
fi

if command -v typst >/dev/null 2>&1; then
  note "typst already present ($(typst --version))."
else
  case "$(uname -m)" in
    x86_64)  target="x86_64-unknown-linux-musl" ;;
    aarch64) target="aarch64-unknown-linux-musl" ;;
    *)       fail "no prebuilt typst for architecture $(uname -m)" ;;
  esac

  # Resolve the asset by pinned URL. Querying the GitHub API for the latest
  # release does not work from a hosted session -- api.github.com returns 403
  # through the session proxy, while the release download itself is allowed.
  url="https://github.com/typst/typst/releases/download/${TYPST_VERSION}/typst-${target}.tar.xz"

  note "Installing typst ${TYPST_VERSION}..."
  tmp="$(mktemp -d)"
  trap 'rm -rf "$tmp"' EXIT

  curl -sSfL --retry 3 --retry-delay 2 -o "$tmp/typst.tar.xz" "$url" \
    || fail "could not download $url"
  tar -xJf "$tmp/typst.tar.xz" -C "$tmp"
  $SUDO install -m755 "$tmp/typst-${target}/typst" /usr/local/bin/typst
fi

missing_cmds=()
for cmd in typst pdfinfo pdftoppm; do
  command -v "$cmd" >/dev/null 2>&1 || missing_cmds+=("$cmd")
done
[[ ${#missing_cmds[@]} -eq 0 ]] || fail "still missing after install: ${missing_cmds[*]}"

# Verify the file, not `typst fonts`. Typst folds Liberation Sans Narrow into
# the "Liberation Sans" family, so the family listing reports a match even when
# only the condensed faces exist -- and the resume then renders condensed.
[[ -f "$LIBERATION_SANS" ]] \
  || fail "$LIBERATION_SANS missing; resumes would render in a substituted face"

note "PDF toolchain ready: $(typst --version), $(pdfinfo -v 2>&1 | head -1)"
