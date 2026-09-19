---
name: job-picker
description: Choose what job to apply to next from the Notion Job Applications database by ranking existing cards for priority, readiness, urgency, fit, and risk.
---

# Job Picker

Recommend the best existing Notion application card to act on next.

## Boundary

Ranking is read-only by default. Do not create branches, job folders, tailored materials, emails, or Notion updates. If the user chooses a role and asks to apply or update tracking, read [references/handoff.md](references/handoff.md).

## Source

Use Notion `Job Applications` as the source of truth.

- Database: `https://app.notion.com/p/928353dcd03642e4a4c606447814fd28`
- Data source: `collection://a8ea6441-a6f7-47dc-ad93-c8a2becc3e92`
- Core fields: `Role`, `Company`, `Stage`, `Priority`, `Tags`, `Job Posting`, `Location`, `Pay`, `Next Action Date`, `Job Closing Date`, `Source`, `Notes`

Fetch the schema when it may have changed. Prefer structured queries, with Notion search as fallback. Fetch full pages for top candidates rather than ranking from snippets.

If the current agent has no Notion connection, report that the picker cannot rank live cards; do not substitute stale guesses or mutate local files.

Exclude `Applied`, `Follow Up`, `Interviewing`, and `Closed` unless the user asks about those stages.

## Ranking

Prioritize:

1. `High` priority and `Top choice`.
2. `Ready to Apply`, then `Tailoring`, `Researching`, and `Inbox`.
3. A live canonical application URL.
4. Closing-date or next-action urgency.
5. Evidence-backed fit with `resume/master_resume.md` and card notes.
6. Realistic seniority, location, work mode, and application requirements.

Penalize stale aggregator-only postings, missing core details, significant seniority mismatch, and roles with weaker readiness or fit than available alternatives.

## Output

Return one to three `Apply now` recommendations with concise fit and urgency reasons, the main risk, Notion and posting URLs, and the exact handoff command for the user's agent:

- Codex: `$job-application ...`
- Claude Code or Cursor: `/job-application ...`

If no card is ready, recommend the single most useful next triage action, such as verifying the source, filling missing requirements, or correcting priority or stage. Do not mutate Notion unless requested.

## Conditional Actions

Read [references/handoff.md](references/handoff.md) only when the user asks to update a card or begin applying. Read [references/tracking.md](references/tracking.md) only after such a meaningful mutation.
