#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
cd "$ROOT_DIR"

fail() {
  printf 'error: %s\n' "$1" >&2
  exit 1
}

skills=(create-job-leads job-picker job-application)

for skill in "${skills[@]}"; do
  canonical=".agents/skills/$skill"
  claude_link=".claude/skills/$skill"

  [[ -f "$canonical/SKILL.md" ]] || fail "missing $canonical/SKILL.md"
  grep -q "^name: $skill$" "$canonical/SKILL.md" || fail "invalid name for $skill"
  grep -q '^description: .\+' "$canonical/SKILL.md" || fail "missing description for $skill"
  [[ -L "$claude_link" ]] || fail "$claude_link is not a symlink"

  canonical_path="$(cd "$canonical" && pwd -P)"
  linked_path="$(cd "$claude_link" && pwd -P)"
  [[ "$canonical_path" == "$linked_path" ]] || fail "$claude_link targets the wrong directory"
done

references=(intake strategy artifacts tracking wrap-up)
for reference in "${references[@]}"; do
  path=".agents/skills/job-application/references/$reference.md"
  [[ -f "$path" ]] || fail "missing $path"
  grep -q "references/$reference.md" .agents/skills/job-application/SKILL.md \
    || fail "$path is not routed from job-application/SKILL.md"
done

for route in \
  create-job-leads:tracking \
  create-job-leads:handoff \
  job-picker:tracking \
  job-picker:handoff; do
  skill="${route%%:*}"
  reference="${route##*:}"
  path=".agents/skills/$skill/references/$reference.md"
  [[ -f "$path" ]] || fail "missing $path"
  grep -q "references/$reference.md" ".agents/skills/$skill/SKILL.md" \
    || fail "$path is not routed from $skill/SKILL.md"
done

state_template="resume/templates/application_state.md"
[[ -f "$state_template" ]] || fail "missing $state_template"
for field in company role phase canonical_posting_url notion_page_id branch next_action open_items; do
  grep -q -- "- $field:" "$state_template" || fail "state template is missing $field"
done

legacy_prompts=(ats_keyword_check start_job_application tailor_resume)
for prompt in "${legacy_prompts[@]}"; do
  [[ -f "resume/prompts/legacy/$prompt.md" ]] || fail "missing archived prompt $prompt.md"
  [[ ! -e "resume/prompts/$prompt.md" ]] || fail "superseded prompt $prompt.md is still active"
done

git diff --check
printf 'Agent workflow validation passed.\n'
