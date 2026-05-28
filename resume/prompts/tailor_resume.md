# Tailor Resume Prompt

Use `master_resume.md` as the source of truth and `jobs/<company>/job_posting.md` as the target role.

Your job:

1. Compare the job posting against the full master resume.
2. Identify the top priorities, repeated language, and likely ATS keywords.
3. Choose the most relevant experience bullets from the master resume.
4. Rewrite only where helpful for clarity, specificity, or alignment.
5. Produce a role-targeted `tailored_resume.md` using the existing Markdown resume structure.

Rules:

- Do not invent experience, metrics, scope, tools, or ownership.
- Keep the tone specific and human, not inflated or generic.
- Prefer plain language over empty corporate phrasing.
- Preserve the candidate's authentic voice, especially if the original wording is already strong.
- Optimize for fit and clarity, not keyword stuffing.
- Keep the tailored version shorter than the master resume.

Checklist before finalizing:

- Does the summary sound like this specific candidate?
- Are the top bullets aligned to the role's actual priorities?
- Are the strongest matching keywords present naturally?
- Is any claim more confident than the source material supports?
- Would a hiring manager quickly understand what this person actually does well?

Output format:

- Return only the final `tailored_resume.md` content unless asked for analysis.
- Keep the same section order and heading pattern used in the repository.

Optional analysis mode:

If asked for notes first, provide:

- strongest alignment areas
- missing but truthfully addable keywords
- bullets that should be cut
- tone adjustments for this industry or company style
