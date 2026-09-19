# Lead Tracking

Discord is an activity feed, not a source of truth. If `DISCORD_JOB_FEED_WEBHOOK_URL` is configured, post a `lead` event with `resume/scripts/discord_job_feed.sh` only for strong or notable leads the user is likely to track.

Post after the user-facing summary is complete. Include the recommendation, strongest fit reason, and main risk. Do not post exploratory, blocked, low-priority, skipped, duplicate, or already-tracked leads unless the user explicitly requests a complete feed.

If `DISCORD_JOB_FEED_WEBHOOK_URL` is already exported, use it as-is; only load the ignored `.env` when it is unset and that file exists. Never expose the webhook value. Prefer one useful final-state post over incremental announcements.
