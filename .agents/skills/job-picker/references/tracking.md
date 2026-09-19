# Picker Activity Feed

Do not post to Discord for read-only ranking or recommendations.

After a requested Notion mutation, post one concise final-state event with `resume/scripts/discord_job_feed.sh` when the webhook is configured:

- `updated` for priority, stage, source, or metadata cleanup
- `started` only when the application workflow actually begins

Load the ignored `.env` without exposing the webhook. Do not post before the requested action succeeds.
