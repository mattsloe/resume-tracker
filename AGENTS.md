# Job Application Workflow

This repository is used to manage tailored resumes, cover letters, and application tracking. Follow this workflow when helping with a job application.

For a guided, repeatable application flow, use the repo skill `$job-application`. This is the preferred entry point when the user explicitly asks to apply, tailor materials, or start the application workflow.

If the user shares job links as leads, prospects, or jobs to review without explicitly asking to apply, do not start the `$job-application` workflow, create branches, create Notion cards, or tailor materials. Treat the request as lead generation or lightweight triage unless the user asks to begin an application.

## Source of Truth

- The Notion `Job Applications` page is the source of truth for application tracking.
- At intake, check whether a Notion card already exists for the role. If it does not, create one before resume tailoring starts.
- If the user provides a niche job link such as Handshake, Indeed, LinkedIn, or a recruiter page, try to find the canonical posting on the company's careers site and use that as the primary job source when available.
- The Discord job feed is an activity stream only, not a source of truth. Post concise milestones there when `DISCORD_JOB_FEED_WEBHOOK_URL` is configured.

## Discord Feed

Use `resume/scripts/discord_job_feed.sh` to post human-readable workflow milestones to Discord. Never write the webhook URL into tracked files; load it from the local environment or `.env`.

For skill-driven work, the default behavior is to post once when the skill run completes meaningful progress. Prefer one final-state post over many small updates. Do not post for blocked runs, read-only analysis, or prompts that are still waiting for user input.

Recommended events:

- `lead`: a role is worth keeping warm after lead triage.
- `started`: an application workflow begins.
- `tailoring`: resume or cover-letter tailoring starts or materially changes.
- `built`: a PDF artifact is generated or validated.
- `ready`: materials are ready and the user needs to submit.
- `applied`: the user confirms the application was submitted.
- `follow-up`: a follow-up action is needed.
- `interviewing`: the application moves into an interview stage.
- `closed`: the role is closed, rejected, withdrawn, or no longer worth pursuing.

Automated Notion monitoring is optional and should remain paused unless the user explicitly wants polling. Skill completion posts are the preferred feed path.

Example:

```bash
set -a; source .env; set +a
resume/scripts/discord_job_feed.sh \
  --event started \
  --company "Acme" \
  --role "Software Engineer" \
  --stage "Tailoring" \
  --url "https://example.com/job" \
  --message "Created the application branch and saved the verified posting."
```

## Intake Before Branching

Before creating the application branch, gather or infer:

- company name
- role title
- job posting URL, preferably the company careers URL
- whether a Notion card exists
- any personalized fit details from the user
- application deadline or priority, if available
- whether a cover letter or email is likely needed

If the user has not provided optional personalized details, proceed with the resume materials and leave room to incorporate them later.

## Branch and File Pattern

- Create one Git branch per application after intake is complete.
- Prefer branch names like `resume/<company>-<role>` or `<company>-application`, matching the repository's existing style when present.
- Create a job folder under `resume/jobs/<company>_<role>/`.
- Store the verified posting in `job_posting.md`.
- Create or update `tailored_resume.md`.
- Add `cover_letter.typ` when the role needs one.

## Master Resume Changes

- Treat `resume/master_resume.md` as the long-form inventory of truthful source material.
- If application work reveals a reusable bullet, project, skill, or framing that belongs in the master resume, make that change in a separate commit from job-specific tailoring.
- Keep that commit cherry-pickable back to `main`.
- Do not mix master resume improvements with job-specific resume or cover-letter changes.

## Iteration Loop

1. Analyze the job posting for responsibilities, priorities, language, and ATS keywords.
2. Draft or revise the tailored resume from `master_resume.md`; do not invent facts, metrics, tools, or ownership.
3. Draft or revise the cover letter if useful for the application channel.
4. Build or validate generated artifacts when the repo provides a build path.
5. Iterate based on user feedback.
6. Keep commits scoped: job analysis, resume tailoring, cover letter, final polish, and master resume improvements as separate commits where practical.
7. Post Discord feed milestones when they help the user keep track of progress.

## Apply Step

When the user asks how to apply:

- Summarize the application path with the best URL or email address.
- List the exact materials to submit.
- Draft an application email when email submission or referral outreach is applicable.
- Note any missing details the user must fill in manually, such as salary expectations, references, or portfolio links.
- Update the Notion card status and relevant metadata when requested.

## Wrap-Up

After the application materials are final:

- Return to `main` when requested.
- Cherry-pick only the reusable master resume commits back to `main`.
- Leave job-specific application commits on the application branch unless the user asks otherwise.
- Make sure Notion remains aligned with the actual application status.
