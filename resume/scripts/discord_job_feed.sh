#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'USAGE'
Usage:
  resume/scripts/discord_job_feed.sh --event EVENT --company COMPANY --role ROLE [options]

Required:
  --event EVENT       One of: lead, started, tailoring, built, ready, applied, follow-up, interviewing, closed, updated, note
  --company COMPANY   Company name
  --role ROLE         Role title

Options:
  --stage STAGE       Current workflow stage
  --url URL           Job posting, Notion card, or application URL
  --message TEXT      Short human-readable detail
  --file PATH         Relevant local artifact path
  --dry-run           Print the Discord payload instead of posting it

Environment:
  DISCORD_JOB_FEED_WEBHOOK_URL must be set unless --dry-run is used.
USAGE
}

json_escape() {
  local value=${1-}
  value=${value//\\/\\\\}
  value=${value//\"/\\\"}
  value=${value//$'\n'/\\n}
  value=${value//$'\r'/}
  printf '%s' "$value"
}

event=""
company=""
role=""
stage=""
url=""
message=""
file_path=""
dry_run="false"

while [[ $# -gt 0 ]]; do
  case "$1" in
    --event)
      event=${2-}
      shift 2
      ;;
    --company)
      company=${2-}
      shift 2
      ;;
    --role)
      role=${2-}
      shift 2
      ;;
    --stage)
      stage=${2-}
      shift 2
      ;;
    --url)
      url=${2-}
      shift 2
      ;;
    --message)
      message=${2-}
      shift 2
      ;;
    --file)
      file_path=${2-}
      shift 2
      ;;
    --dry-run)
      dry_run="true"
      shift
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      printf 'Unknown argument: %s\n\n' "$1" >&2
      usage >&2
      exit 2
      ;;
  esac
done

if [[ -z "$event" || -z "$company" || -z "$role" ]]; then
  usage >&2
  exit 2
fi

case "$event" in
  lead) title="New lead" ;;
  started) title="Application started" ;;
  tailoring) title="Tailoring in progress" ;;
  built) title="Materials built" ;;
  ready) title="Ready to apply" ;;
  applied) title="Application submitted" ;;
  follow-up) title="Follow-up needed" ;;
  interviewing) title="Interviewing" ;;
  closed) title="Application closed" ;;
  updated) title="Application updated" ;;
  note) title="Job search note" ;;
  *)
    printf 'Unsupported event: %s\n' "$event" >&2
    exit 2
    ;;
esac

description="**${company} - ${role}**"
if [[ -n "$stage" ]]; then
  description="${description}\nStage: ${stage}"
fi
if [[ -n "$message" ]]; then
  description="${description}\n${message}"
fi
if [[ -n "$file_path" ]]; then
  description="${description}\nFile: \`${file_path}\`"
fi
if [[ -n "$url" ]]; then
  description="${description}\n${url}"
fi

payload=$(printf '{"username":"Job Application Feed","embeds":[{"title":"%s","description":"%s","color":5793266}]}' \
  "$(json_escape "$title")" \
  "$(json_escape "$description")")

if [[ "$dry_run" == "true" ]]; then
  printf '%s\n' "$payload"
  exit 0
fi

if [[ -z "${DISCORD_JOB_FEED_WEBHOOK_URL:-}" ]]; then
  printf 'DISCORD_JOB_FEED_WEBHOOK_URL is not set.\n' >&2
  exit 1
fi

curl --fail --silent --show-error \
  -H 'Content-Type: application/json' \
  -d "$payload" \
  "$DISCORD_JOB_FEED_WEBHOOK_URL" >/dev/null

printf 'Posted %s update for %s - %s\n' "$event" "$company" "$role"
