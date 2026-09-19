# Resume Tracker

A lightweight, git-backed system for managing a master resume, job-specific
tailoring, cover letters, and repeatable AI workflows.

The repo is intentionally plain text first:

- Markdown stores resume source, prompts, job postings, and workflow notes.
- Typst renders polished PDF outputs from Markdown resume files.
- `.agents/skills/` stores portable workflow instructions that Codex and other
  LLM agents can read.
- `AGENTS.md` gives repository-wide rules for job applications and tracking.

## Quick Start

Read these files first:

- `AGENTS.md` for the canonical job-application workflow.
- `resume/README.md` for file layout, resume format, and PDF export commands.
- `.agents/skills/job-application/SKILL.md` when starting an application.
- `.agents/skills/create-job-leads/SKILL.md` when researching leads only.
- `.agents/skills/job-picker/SKILL.md` when choosing from existing Notion cards.

To build a resume PDF:

```bash
cd resume
./scripts/build.sh master_resume.md
./scripts/build.sh jobs/example_job/tailored_resume.md
```

Exports are written to `resume/exports/`.

## Using With Other LLMs

For tools such as Claude, Gemini, or local agents that do not natively understand
Codex skills, treat each `SKILL.md` file as a short operating manual.

Recommended context packet:

1. `AGENTS.md`
2. The relevant `.agents/skills/*/SKILL.md`
3. `resume/README.md`
4. `resume/master_resume.md`
5. The target job posting or Notion notes, when applicable

Important boundaries:

- Do not start the application workflow for simple lead review.
- Do not invent resume facts, metrics, tools, ownership, or credentials.
- Use one branch per application.
- Keep reusable `resume/master_resume.md` improvements separate from
  job-specific tailoring.
- Prefer canonical company career pages over aggregator postings.

## Main Workflows

- `$create-job-leads`: research or triage roles before deciding to apply.
- `$job-picker`: rank existing Notion job cards and choose what to apply to next.
- `$job-application`: create or continue an application, including Notion
  tracking, branch setup, tailored resume work, cover letters, and apply steps.

These names are Codex skill triggers, but the files are regular Markdown and can
be copied into any LLM session as instructions.

## Discord Job Feed

The repo can post lightweight activity updates to a Discord channel through a
channel webhook. Keep the webhook URL out of git:

```bash
cp .env.example .env
```

Then edit `.env` locally and set:

```bash
DISCORD_JOB_FEED_WEBHOOK_URL="https://discord.com/api/webhooks/..."
```

Post a workflow milestone with:

```bash
set -a; source .env; set +a
resume/scripts/discord_job_feed.sh \
  --event started \
  --company "Acme" \
  --role "Software Engineer" \
  --stage "Tailoring" \
  --message "Created the application branch and saved the verified posting."
```

Supported events are `lead`, `started`, `tailoring`, `built`, `ready`,
`applied`, `follow-up`, `interviewing`, `closed`, `updated`, and `note`.

The repo skills are configured to post once when a skill run completes meaningful
progress. Automated polling is optional; skill completion posts are the preferred
way to keep the feed accurate without duplicate or inferred updates.
