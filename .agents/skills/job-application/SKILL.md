---
name: job-application
description: Use when the user wants to apply for a job, start a job application, tailor a resume or cover letter for a role, track a job in Notion, or asks how to apply. This skill walks through the repeatable job-application workflow from intake through Notion tracking, branch setup, resume and cover-letter iteration, application instructions, email drafting, and main-branch cherry-picks.
---

# Job Application

Use this skill to make applying for a job easy and repeatable, especially from a short mobile prompt.

## Mobile Intake

Accept a minimal first message such as:

```text
$job-application https://example.com/job
```

or:

```text
$job-application Data Analyst at Acme. I have a Notion card already. I am a strong fit because ...
```

Do not require all details up front. Start with what the user gave, infer what is reasonable, and ask only for missing details that block the next step.

## Source Of Truth

- Use the Notion `Job Applications` page as the source of truth for tracking.
- Check whether a matching Notion card exists before creating a branch.
- If there is no matching card, create one.
- Keep the card aligned with the current stage when the user asks for updates.

## Posting Verification

- If the user gives a niche link such as Handshake, Indeed, LinkedIn, a recruiter page, or a school job board, look for the canonical posting on the company's careers site.
- Prefer the company careers posting as the primary source when available.
- Save the verified posting in `resume/jobs/<company>_<role>/job_posting.md`.

## Before Branching

Gather or infer:

- company
- role title
- original link
- canonical company careers link, if different
- Notion card status
- deadline or priority, if available
- personalized fit notes, if provided
- expected materials: resume, cover letter, email, portfolio, references

If optional personalized details are missing, continue and leave room to add them later.

## Branch And Files

After intake:

1. Create one branch for the application, using the repository's existing branch style.
2. Create `resume/jobs/<company>_<role>/`.
3. Save the posting as `job_posting.md`.
4. Draft or update `tailored_resume.md` from `resume/master_resume.md`.
5. Add `cover_letter.typ` when useful for the role or application channel.

## Master Resume Rule

Treat `resume/master_resume.md` as the long-form source inventory.

If application work reveals a reusable improvement for the master resume, commit it separately from job-specific work so it can be cherry-picked back to `main`.

Examples:

- new truthful bullet variant
- stronger project framing
- newly remembered tool, responsibility, or outcome
- reusable summary language

Do not mix master-resume improvements with tailored resume or cover-letter commits.

## Iteration Loop

For each pass:

1. Analyze the posting for responsibilities, priorities, language, and ATS keywords.
2. Compare the posting against `resume/master_resume.md`.
3. Identify strongest alignments and missing-but-truthful keywords.
4. Update `tailored_resume.md` without inventing facts, metrics, tools, or ownership.
5. Update the cover letter or email draft when applicable.
6. Build or validate generated artifacts when the repo provides a build path.
7. Incorporate user feedback.

Keep commits scoped where practical:

- job analysis
- resume tailoring
- cover letter
- final polish
- separate master-resume improvements

## Applying

When the user asks "how do I apply?":

- provide the best application URL or email path
- list exact files and materials to submit
- draft an application email when applicable
- identify manual fields the user must fill in
- suggest the Notion status update

## Wrap-Up

When the application is complete:

1. Commit final application materials if requested or appropriate.
2. Switch back to `main` when requested.
3. Cherry-pick only reusable master-resume commits back to `main`.
4. Leave job-specific application history on its application branch unless the user asks otherwise.
5. Confirm the Notion card reflects the final status.
