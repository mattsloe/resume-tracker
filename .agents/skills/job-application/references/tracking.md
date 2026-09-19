# Notion And Discord Tracking

Use this reference only when external tracking needs to be read or changed.

## Notion

Notion `Job Applications` is the status source of truth. Reuse the page ID and URL cached in `application_state.md`; search again only when the cache is missing or invalid.

Keep the card aligned with confirmed reality. Do not mark an application `Applied` until the user confirms submission. Avoid speculative status changes.

## Discord

Discord is an activity stream, not tracking state. If `DISCORD_JOB_FEED_WEBHOOK_URL` is configured, post one concise final-state event after a run makes meaningful progress. Do not post for read-only analysis, blocked work, minor edits, or prompts awaiting user input.

Use `resume/scripts/discord_job_feed.sh`. If `DISCORD_JOB_FEED_WEBHOOK_URL` is already exported, use it as-is; only load the ignored `.env` when it is unset and that file exists. Never expose the webhook value. Choose the furthest confirmed event reached: `started`, `tailoring`, `built`, `ready`, `applied`, `follow-up`, `interviewing`, or `closed`.

One post per run is the default. A second is justified only when the user confirms a distinct later milestone in the same run.
