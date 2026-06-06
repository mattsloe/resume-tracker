#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
INPUT_PATH="${1:-master_resume.md}"
OUTPUT_NAME="${2:-}"

if ! command -v typst >/dev/null 2>&1; then
  echo "Error: Typst is not installed." >&2
  echo "Install it first: https://typst.app/open-source/" >&2
  exit 1
fi

trim() {
  local value="$1"
  value="${value#"${value%%[![:space:]]*}"}"
  value="${value%"${value##*[![:space:]]}"}"
  printf '%s' "$value"
}

escape_typst() {
  printf '%s' "$1" | sed -e 's/\\/\\\\/g' -e 's/"/\\"/g'
}

append_line() {
  local target="$1"
  local line="$2"
  printf -v "$target" '%s%s\n' "${!target}" "$line"
}

resolve_input() {
  local candidate="$1"
  if [[ "$candidate" = /* ]]; then
    printf '%s' "$candidate"
  else
    printf '%s/%s' "$ROOT_DIR" "$candidate"
  fi
}

default_output_name() {
  local input="$1"
  local relative="${input#"$ROOT_DIR"/}"
  local parent
  parent="$(basename "$(dirname "$relative")")"
  local base
  base="$(basename "$relative" .md)"

  if [[ "$parent" == "jobs" || "$relative" == "master_resume.md" ]]; then
    printf '%s.pdf' "$base"
    return
  fi

  if [[ "$base" == "tailored_resume" && "$parent" != "." ]]; then
    printf '%s_resume.pdf' "$parent"
  else
    printf '%s.pdf' "$base"
  fi
}

build_item() {
  local title="$1"
  local meta="$2"
  local dates="$3"
  local bullets="$4"
  cat <<EOF
    (
      title: "$(escape_typst "$title")",
      meta: "$(escape_typst "$meta")",
      dates: "$(escape_typst "$dates")",
      bullets: (
${bullets}      ),
    ),
EOF
}

flush_entry() {
  if [[ -z "${ENTRY_TITLE:-}" ]]; then
    return
  fi

  local rendered
  rendered="$(build_item "$ENTRY_TITLE" "$ENTRY_META" "$ENTRY_DATES" "$ENTRY_BULLETS")"

  case "$ENTRY_SECTION" in
    Experience)
      append_line EXPERIENCE_BLOCK "$rendered"
      ;;
    Projects)
      append_line PROJECTS_BLOCK "$rendered"
      ;;
    Education)
      append_line EDUCATION_BLOCK "$rendered"
      ;;
  esac

  ENTRY_TITLE=""
  ENTRY_META=""
  ENTRY_DATES=""
  ENTRY_BULLETS=""
}

start_entry() {
  local raw="$1"
  local section="$2"
  local body="${raw#\#\#\# }"
  local -a parts=()
  IFS='|' read -r -a parts <<< "$body"

  local part1="${parts[0]:-}"
  local part2="${parts[1]:-}"
  local part3="${parts[2]:-}"
  local part4="${parts[3]:-}"

  part1="$(trim "$part1")"
  part2="$(trim "$part2")"
  part3="$(trim "$part3")"
  part4="$(trim "$part4")"

  flush_entry
  ENTRY_SECTION="$section"
  ENTRY_TITLE="$part1"
  ENTRY_BULLETS=""

  if [[ "$section" == "Projects" ]]; then
    ENTRY_META="$part2"
    ENTRY_DATES="$part3"
    if [[ -n "$part4" ]]; then
      if [[ -n "$ENTRY_META" ]]; then
        ENTRY_META="$ENTRY_META · $part3"
      else
        ENTRY_META="$part3"
      fi
      ENTRY_DATES="$part4"
    fi
    return
  fi

  if [[ -n "$part4" ]]; then
    ENTRY_META="$part2"
    if [[ -n "$part3" ]]; then
      if [[ -n "$ENTRY_META" ]]; then
        ENTRY_META="$ENTRY_META · $part3"
      else
        ENTRY_META="$part3"
      fi
    fi
    ENTRY_DATES="$part4"
  else
    ENTRY_META="$part2"
    ENTRY_DATES="$part3"
  fi
}

SOURCE_FILE="$(resolve_input "$INPUT_PATH")"

if [[ ! -f "$SOURCE_FILE" ]]; then
  echo "Error: Resume source not found: $INPUT_PATH" >&2
  exit 1
fi

mkdir -p "$ROOT_DIR/exports"

if [[ -n "$OUTPUT_NAME" ]]; then
  if [[ "$OUTPUT_NAME" == *.pdf ]]; then
    OUTPUT_FILE="$ROOT_DIR/exports/$OUTPUT_NAME"
  else
    OUTPUT_FILE="$ROOT_DIR/exports/$OUTPUT_NAME.pdf"
  fi
else
  OUTPUT_FILE="$ROOT_DIR/exports/$(default_output_name "$SOURCE_FILE")"
fi

BUILD_DIR="$ROOT_DIR/.build"
mkdir -p "$BUILD_DIR"
WRAPPER_BASE="$(mktemp "$BUILD_DIR/resume.XXXXXX")"
WRAPPER_FILE="$WRAPPER_BASE.typ"
mv "$WRAPPER_BASE" "$WRAPPER_FILE"

cleanup() {
  rm -f "$WRAPPER_FILE"
  rmdir "$BUILD_DIR" 2>/dev/null || true
}
trap cleanup EXIT

NAME=""
HEADLINE=""
CONTACT=""
CURRENT_SECTION=""
ENTRY_SECTION=""
ENTRY_TITLE=""
ENTRY_META=""
ENTRY_DATES=""
ENTRY_BULLETS=""
SUMMARY_BLOCK=""
EXPERIENCE_BLOCK=""
PROJECTS_BLOCK=""
SKILLS_BLOCK=""
EDUCATION_BLOCK=""
PAGEBREAK_BEFORE_PROJECTS="false"

while IFS= read -r raw_line || [[ -n "$raw_line" ]]; do
  line="${raw_line%$'\r'}"
  trimmed="$(trim "$line")"

  if [[ "$trimmed" == "<!-- pagebreak-before: Projects -->" ]]; then
    PAGEBREAK_BEFORE_PROJECTS="true"
    continue
  fi

  if [[ "$trimmed" == \#\ * && -z "$NAME" ]]; then
    NAME="$(trim "${trimmed#\# }")"
    continue
  fi

  if [[ "$trimmed" == \#\#\ * ]]; then
    flush_entry
    CURRENT_SECTION="$(trim "${trimmed#\#\# }")"
    continue
  fi

  if [[ -z "$CURRENT_SECTION" ]]; then
    if [[ -n "$trimmed" && -z "$HEADLINE" ]]; then
      HEADLINE="$trimmed"
      continue
    fi

    if [[ -n "$trimmed" && -z "$CONTACT" ]]; then
      CONTACT="$trimmed"
      continue
    fi

    continue
  fi

  if [[ "$trimmed" == \#\#\#\ * ]]; then
    start_entry "$trimmed" "$CURRENT_SECTION"
    continue
  fi

  if [[ -z "$trimmed" ]]; then
    continue
  fi

  case "$CURRENT_SECTION" in
    Summary)
      append_line SUMMARY_BLOCK "    \"$(escape_typst "$trimmed")\","
      ;;
    Experience|Projects|Education)
      if [[ "$trimmed" == -\ * ]]; then
        append_line ENTRY_BULLETS "        \"$(escape_typst "${trimmed#- }")\","
      else
        append_line ENTRY_BULLETS "        \"$(escape_typst "$trimmed")\","
      fi
      ;;
    Skills)
      if [[ "$trimmed" == *:* ]]; then
        skill_label="$(trim "${trimmed%%:*}")"
        skill_items="$(trim "${trimmed#*:}")"
      else
        skill_label="General"
        skill_items="$trimmed"
      fi
      append_line SKILLS_BLOCK "    (label: \"$(escape_typst "$skill_label")\", items: \"$(escape_typst "$skill_items")\"),"
      ;;
  esac
done < "$SOURCE_FILE"

flush_entry

cat > "$WRAPPER_FILE" <<EOF
#import "/templates/resume.typ": render_resume

#render_resume(
  "$(escape_typst "$NAME")",
  "$(escape_typst "$HEADLINE")",
  "$(escape_typst "$CONTACT")",
  (
${SUMMARY_BLOCK}  ),
  (
${EXPERIENCE_BLOCK}  ),
  (
${PROJECTS_BLOCK}  ),
  (
${SKILLS_BLOCK}  ),
  (
${EDUCATION_BLOCK}  ),
  pagebreak_before_projects: $PAGEBREAK_BEFORE_PROJECTS,
)
EOF

typst compile --root "$ROOT_DIR" "$WRAPPER_FILE" "$OUTPUT_FILE"
echo "Built $OUTPUT_FILE"
