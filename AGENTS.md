# Job Application Workflow

This repository is used to manage tailored resumes, cover letters, and application tracking. Follow this workflow when helping with a job application.

For a guided, repeatable application flow, use the repo skill `$job-application`. This is the preferred entry point for short mobile prompts such as a job link plus a few fit notes.

## Source of Truth

- The Notion `Job Applications` page is the source of truth for application tracking.
- At intake, check whether a Notion card already exists for the role. If it does not, create one before resume tailoring starts.
- If the user provides a niche job link such as Handshake, Indeed, LinkedIn, or a recruiter page, try to find the canonical posting on the company's careers site and use that as the primary job source when available.

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
