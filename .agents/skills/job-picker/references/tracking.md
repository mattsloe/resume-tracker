# Picker Activity Feed

Do not post to Discord for read-only ranking or recommendations.

After a requested Notion mutation, post one concise final-state event with `resume/scripts/discord_job_feed.sh` when the webhook is configured:

- `updated` for priority, stage, source, or metadata cleanup
- `started` only when the application workflow actually begins

If `DISCORD_JOB_FEED_WEBHOOK_URL` is already exported, use it as-is; only load the ignored `.env` when it is unset and that file exists. Never expose the webhook value. Do not post before the requested action succeeds.
