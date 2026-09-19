# Intake And Setup

Use this reference for a new application or when core identifiers are missing.

## Establish The Role

Gather or infer company, role title, original URL, canonical URL, deadline or priority, user fit notes, and likely required materials. Optional fit notes should not block progress.

If the source is LinkedIn, Indeed, Handshake, a recruiter page, or another aggregator, look for the live posting on the employer's careers site. Save the verified posting to `job_posting.md`; retain the original URL in `application_state.md` when it differs.

## Tracking Check

Search Notion `Job Applications` for the company and role before creating anything. Reuse a matching card and cache its page ID and URL. If none exists, create one only when the user's request authorizes beginning the application workflow.

If the current agent has no Notion connection, do not invent tracking state. Continue local work when possible and record the Notion check as an open item.

## Local Setup

After the identity and tracking check:

1. Create or switch to a branch matching the repository's existing application-branch style.
2. Create `resume/jobs/<company>_<role>/`.
3. Copy `resume/templates/application_state.md` into the folder and fill known fields.
4. Save the posting as `job_posting.md`.
5. Set `phase: intake`, record completed setup, and set `next_action: Write strategy.md`.

Do not create a second branch, folder, or Notion card when continuing existing work. Confirm existing state first.
