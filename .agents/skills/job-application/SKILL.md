---
name: job-application
description: Apply for a job, tailor a resume or cover letter, track an application in Notion, or prepare submission instructions. Use for active applications; use create-job-leads for research or triage before the user chooses to apply.
---

# Job Application

Move an application forward from a minimal prompt while preserving truthful claims and resumable state.

## Non-Negotiables

- Never invent experience, metrics, tools, credentials, or ownership.
- Notion `Job Applications` is the tracking source of truth. `application_state.md` is only a local continuation cache.
- Check for a matching Notion card before creating one.
- Prefer a verified company careers posting over an aggregator when available.
- Finish the current requested phase; do not redo completed phases.
- Ask only when missing information blocks the next action or a required qualification cannot be verified.

## Resume A Run

If `resume/jobs/<company>_<role>/application_state.md` exists, read it first and continue from `next_action`. For an older job folder without state, inspect its existing artifacts and bootstrap the state file without repeating completed work. Start at intake only for a genuinely new application.

Update the state file after meaningful progress. Keep it factual and compact: identifiers, phase, decisions, outputs, and unresolved items. Cache the Notion page ID/URL and canonical posting URL there so later turns do not need to rediscover them.

## Phase Router

Read only the reference needed for the current request:

- New application, posting verification, Notion lookup, branch/folder setup: [references/intake.md](references/intake.md)
- Fit analysis, ATS mapping, resume or cover-letter drafting: [references/strategy.md](references/strategy.md)
- Build, PDF generation, or layout verification: [references/artifacts.md](references/artifacts.md)
- Notion status or Discord activity updates: [references/tracking.md](references/tracking.md)
- Submission instructions, application email, completion, or branch cleanup: [references/wrap-up.md](references/wrap-up.md)

Typical phases are `intake`, `strategy`, `draft`, `build`, `ready`, `submitted`, and `closed`. A prompt may cross phases when the work is straightforward; load each reference only when its phase becomes necessary.

## Repository Contract

- Use one branch per application after intake, matching existing branch style.
- Store work under `resume/jobs/<company>_<role>/`.
- Required working files are `application_state.md`, `job_posting.md`, `strategy.md`, and `tailored_resume.md`; add `cover_letter.typ` only when useful.
- Treat `resume/master_resume.md` as the long-form inventory of truthful source material.
- Keep reusable master-resume improvements in a separate commit from job-specific work so they can be cherry-picked to `main`.
- Generate submission documents as PDFs unless the user requests another format. Render and inspect changed PDFs before making visual claims.

## Completion

At the end of a run, report the phase reached, artifacts changed, any user-owned next action, and unresolved items. Update local state. Perform external tracking updates only when authorized by the request and the relevant reference.
