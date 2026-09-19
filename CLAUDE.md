# Claude Entry Point

Use this repository as a plain-text resume and job-application workflow system.

Read in this order:

1. `AGENTS.md`
2. The relevant `.agents/skills/*/SKILL.md`
3. `resume/README.md`
4. `resume/master_resume.md`
5. Any target job posting or Notion notes supplied by the user

Workflow selection:

- Use `.agents/skills/create-job-leads/SKILL.md` for job lead research or triage.
- Use `.agents/skills/job-picker/SKILL.md` to rank existing Notion application cards.
- Use `.agents/skills/job-application/SKILL.md` only when the user wants to apply,
  tailor materials, draft cover letters, or update application tracking.

Hard rules:

- Do not invent resume facts, metrics, tools, ownership, credentials, or outcomes.
- Do not create branches, Notion cards, job folders, tailored resumes, or cover
  letters for lead-review tasks unless the user explicitly asks to apply.
- Keep reusable `resume/master_resume.md` improvements separate from
  job-specific application edits.
- Prefer canonical company career postings over aggregators when available.
