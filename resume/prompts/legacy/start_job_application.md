# Start Job Application Prompt

Use this prompt when starting a new application.

## Intake

Given the user's target role, collect or infer:

- company
- role title
- original job link
- canonical company careers link, if different
- existing Notion card status
- application deadline or priority
- user's personalized fit notes
- expected materials: resume, cover letter, email, portfolio, references

If the user gives a niche listing link, search for the main company careers posting and prefer that posting as the source for `job_posting.md`.

## Notion

Use the Notion `Job Applications` page as the application tracker.

- If a matching card exists, use it.
- If no matching card exists, create one.
- Keep the card aligned with the current state of the application.

## Git Setup

Do intake before creating the application branch.

After intake:

1. Create a branch for the application.
2. Create `resume/jobs/<company>_<role>/`.
3. Save the posting as `job_posting.md`.
4. Draft `tailored_resume.md` from `resume/master_resume.md`.
5. Add `cover_letter.typ` only when useful.

## Master Resume Rule

If new reusable source material belongs in `resume/master_resume.md`, commit it separately from job-specific work so it can be cherry-picked back to `main`.

Examples:

- new truthful bullet variant
- stronger project framing
- newly remembered tool, responsibility, or outcome
- reusable summary language

Do not mix these with tailored resume or cover-letter commits.

## Iteration

For each pass:

1. Compare the posting against the master resume.
2. Identify the strongest alignments and missing-but-truthful keywords.
3. Update the tailored resume.
4. Update the cover letter or email draft if applicable.
5. Validate formatting/build output when possible.
6. Ask for or incorporate user feedback.

## Final Apply Request

When the user asks "how do I apply?":

- provide the best application URL or email path
- list the exact files/materials to submit
- draft the email if applicable
- identify required manual fields
- suggest the Notion status update

## Wrap-Up

When the application is complete:

1. Commit final application materials.
2. Switch back to `main` when requested.
3. Cherry-pick only reusable master resume commits.
4. Confirm the Notion card reflects the final status.
