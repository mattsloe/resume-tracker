---
name: job-picker
description: Use when the user wants to choose what job to apply to next from their Notion Job Applications database, rank existing Notion cards by priority/readiness/fit, inspect application pipeline cards, or hand off a selected Notion job card into the job-application workflow.
---

# Job Picker

Use this skill to help the user decide which existing Notion job card to apply to next. This is a picker and triage workflow, not the application-materials workflow.

## Boundary

Do not create branches, job folders, tailored resumes, cover letters, or application emails unless the user chooses a role and asks to apply. At that point, hand off to `$job-application`.

Only update Notion when the user explicitly asks. Ranking and recommendations are read-only by default.

## Source

Use the Notion `Job Applications` database as the source of truth.

- Database: `Job Applications`
- Database URL: `https://app.notion.com/p/928353dcd03642e4a4c606447814fd28`
- Data source: `collection://a8ea6441-a6f7-47dc-ad93-c8a2becc3e92`

Important fields:

- `Role` title
- `Company`
- `Stage`: `Inbox`, `Researching`, `Tailoring`, `Ready to Apply`, `Applied`, `Follow Up`, `Interviewing`, `Closed`
- `Priority`: `High`, `Medium`, `Low`
- `Tags`: `Remote`, `Hybrid`, `On-site`, `Stretch`, `Top choice`, `Nonprofit`
- `Job Posting`
- `Location`
- `Pay`
- `Next Action Date`
- `Job Closing Date`
- `Source`
- `Notes`

## Query Workflow

1. Fetch the database first if the schema may have changed.
2. Prefer structured database queries against `collection://a8ea6441-a6f7-47dc-ad93-c8a2becc3e92`.
3. Exclude cards in `Applied`, `Follow Up`, `Interviewing`, or `Closed` unless the user asks about follow-up work.
4. If structured querying fails, use Notion search and fetch the most relevant cards before ranking.
5. Fetch individual pages for the top candidates so recommendation details come from properties and notes, not snippets.

Useful query intent:

- Apply now: open cards with `Priority = High`, `Stage = Ready to Apply/Tailoring/Researching/Inbox`, nearest closing or next-action date first.
- Fast win: `Ready to Apply` or `Tailoring`, then high/medium priority.
- Best fit: `High` priority or `Top choice`, then compare notes against `resume/master_resume.md`.
- Local/community fit: tags or notes mentioning Portland, hybrid, nonprofit, public sector, housing, planning, data, reporting, operations.
- Software/data fit: role or notes mentioning software, data engineer, systems, TypeScript, React, Python, SQL, automation, infrastructure.

## Ranking Heuristics

Rank cards by:

1. `High` priority and `Top choice`.
2. `Ready to Apply` before `Tailoring`, before `Researching`, before `Inbox`.
3. Clear current application URL and canonical company source.
4. Deadline or next-action urgency.
5. Fit with known resume context: CS graduate, TypeScript/React/Python/SQL/C/C++, systems/data structures, bar inventory app, operations, community research, housing/land-use advocacy, grant/reporting work.
6. Lower risk: realistic seniority, remote/hybrid/local work mode, fewer missing requirements.

Penalize:

- already applied or closed cards
- stale/unclear aggregator-only postings
- seniority mismatches such as 5+ years when stronger early-career cards exist
- missing application URL, pay, location, or requirements when another card is ready

## Output

For a quick picker response, give:

- `Apply now`: 1-3 roles, ranked
- `Why`: concise fit and urgency reasons
- `Risk`: the main concern
- `Apply path`: Notion card URL and posting URL
- `Handoff`: exact `$job-application` prompt to start the application

When there are no obvious apply-now cards, say so and offer the best next triage action: verify source, mark priority, update stage, or research missing requirements.

## Discord Feed

Do not post to Discord for ordinary read-only ranking or picker output.

If the user explicitly asks to update Notion or chooses a role and asks to begin applying, post one completion event only after that meaningful action is complete:

- `updated`: for a Notion triage update, such as priority/stage/source cleanup.
- `started`: when handing off into `$job-application` and the application workflow actually begins.

Use `resume/scripts/discord_job_feed.sh` with the local ignored `.env` loaded. Keep the message short and name the action that was completed. Do not post for recommendations alone.

## Handoff To Job Application

When the user chooses a card and asks to apply, start `$job-application` and carry forward:

- Notion page URL and page ID
- company
- role title
- canonical posting URL
- stage, priority, deadline, and notes
- fit reasons
- risks and missing details
- likely materials needed

Example handoff prompt:

```text
$job-application Start applying to Prophetic Data Engineer from Notion card https://app.notion.com/p/377ebb67ae3781508996f3efa7b5a21a. Canonical posting: https://www.propheticsoftware.ai/open-positions/data-engineer. Prioritize SQL, Python, data collection/reporting, land-use context, and messy real-world data.
```
