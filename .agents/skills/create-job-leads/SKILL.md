---
name: create-job-leads
description: Use when the user wants to collect, research, compare, rank, or lightly triage job leads before deciding whether to apply. Trigger for prompts that share job links as leads, prospects, saved jobs, roles to review, companies to research, or requests to find good-fit openings. This skill prepares apply-ready lead summaries without starting the job-application workflow, creating branches, creating Notion cards, tailoring resumes, or drafting application materials unless the user explicitly asks to apply.
---

# Create Job Leads

Use this skill to turn one or more job leads into a clear shortlist: what the role is, whether it is worth pursuing, why it fits, and what would be needed to apply.

## Boundary

Treat this as lead generation or lightweight triage, not an application workflow.

Do not:

- create a Git branch
- create or update a Notion application card
- create files under `resume/jobs/`
- tailor `resume/master_resume.md`
- draft `tailored_resume.md`, cover letters, or application emails
- update application statuses

If the user explicitly asks to apply, start the `$job-application` workflow instead.

## Intake

Accept minimal prompts such as:

```text
$create-job-leads Review these three roles: <links>
```

```text
Find remote data analyst roles at climate companies that look worth applying to.
```

Gather or infer:

- company name
- role title
- job URL
- location or remote policy
- seniority and employment type
- deadline, closing date, or posted date when available
- compensation when available
- application path
- obvious fit details and risks

Ask a question only when the missing detail changes the search or ranking meaningfully, such as target role family, geography, seniority, or deal-breakers.

## Research

When the user gives job links, inspect each lead and prefer the canonical company careers posting over aggregator pages such as LinkedIn, Indeed, Handshake, Wellfound, recruiter pages, or school boards.

When the user asks to find leads, search current postings and prioritize official company career pages. Because postings change frequently, verify that each selected role appears open before presenting it.

For each role, extract:

- company and role title
- canonical posting URL
- original source URL, if different
- core responsibilities
- required and preferred qualifications
- ATS keywords and tools
- location, remote/hybrid expectations, and work authorization signals
- compensation, if listed
- application requirements, such as resume, cover letter, portfolio, referrals, or assessments
- concerns, such as closed posting, seniority mismatch, location mismatch, salary mismatch, unclear requirements, or questionable source

## Fit Triage

Compare the posting against known resume/project context only when available in the repo or conversation. Do not invent facts, credentials, metrics, tools, degrees, or work authorization.

Classify each lead:

- `Strong lead`: clear fit, credible posting, application path is usable
- `Possible lead`: some fit but has unknowns or weaker alignment
- `Low priority`: meaningful mismatch, weak role quality, duplicate, stale, or poor source
- `Skip`: closed, unavailable, obvious mismatch, or not a real posting

Use concise reasons. Favor evidence from the posting and known candidate context over generic enthusiasm.

## Output

For a small batch, present a ranked list with:

- rank
- company and role
- recommendation
- key fit reasons
- gaps or risks
- canonical apply URL
- materials likely needed
- next action

For larger batches, group into:

- apply soon
- keep warm
- skip
- needs more info

End with a practical next step, such as which role should move into `$job-application`, what detail to verify, or which search filter to adjust.

## Handoff To Application

When the user chooses a lead and asks to apply, transition to `$job-application` and carry forward:

- company
- role title
- canonical posting URL
- original source URL
- fit notes
- concerns and missing details
- likely materials needed

At that point, the application workflow can create the Notion card, branch, job folder, posting file, tailored resume, and cover letter.
