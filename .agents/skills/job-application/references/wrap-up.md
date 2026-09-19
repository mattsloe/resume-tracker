# Apply And Wrap Up

Use this reference when the user asks how to apply, is ready to submit, confirms submission, or wants branch cleanup.

## Ready To Apply

Provide:

- the best application URL or email path
- exact files and materials to submit
- an application email when email submission or outreach applies
- manual fields the user must complete, such as authorization, salary, references, or portfolio links
- unresolved risks or factual questions

Set `phase: ready` only when the materials needed from this repository are complete and validated.

## After Submission

Only after the user confirms submission:

- set local phase to `submitted`
- update Notion to the confirmed status when requested or already authorized
- post the `applied` Discord event when configured
- record any dated follow-up

## Git Wrap-Up

Commit final materials when requested or appropriate to the active workflow. Switch to `main` only when requested. Cherry-pick only separately committed, reusable `master_resume.md` improvements; leave job-specific history on the application branch unless the user asks otherwise.

Finish by reporting the confirmed state, submission artifacts, next user action, and any follow-up date.
