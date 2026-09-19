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
- Write `strategy.md` before drafting resume/cover-letter content: map the
  posting's required/preferred qualifications against truthful evidence,
  and identify the truthful ATS keywords to carry through. See the
  `job-application` skill's Strategy section for the expected shape.
- Create or update `tailored_resume.md`, guided by `strategy.md`.
- Add `cover_letter.typ` when the role needs one, also guided by `strategy.md`.

## Master Resume Changes

- Treat `resume/master_resume.md` as the long-form inventory of truthful source material.
- If application work reveals a reusable bullet, project, skill, or framing that belongs in the master resume, make that change in a separate commit from job-specific tailoring.
- Keep that commit cherry-pickable back to `main`.
- Do not mix master resume improvements with job-specific resume or cover-letter changes.

## Cover Letter Voice

When writing or revising cover letters, optimize for specificity, natural
voice, and credibility, not generic professionalism.

### Matt's voice

Write like an intelligent, grounded person talking to another intelligent
person. The preferred tone is:

- warm but not gushy
- confident without sounding self-important
- conversational without being overly casual
- direct and concise
- thoughtful and specific
- slightly informal when appropriate
- sincere rather than performatively enthusiastic

Sentence structure should vary naturally. Some sentences can be short. Avoid
making every paragraph feel perfectly symmetrical or polished to the point
that it sounds machine-generated.

He would rather sound like a real person with a clear reason for applying
than like an idealized corporate applicant.

### Avoid "cover letter voice"

Do not default to standard AI/corporate cover-letter language. Avoid phrases
and constructions like:

- "I am excited to apply..."
- "I am thrilled at the opportunity..."
- "I believe my skills and experience make me an ideal candidate..."
- "I am confident that I would be a valuable asset..."
- "I am eager to leverage my..."
- "This opportunity strongly aligns with..."
- "Throughout my career..."
- "I would welcome the opportunity to..."
- "I am passionate about..."
- "dynamic team"
- "fast-paced environment"
- "unique blend of..."
- "proven track record"
- "results-driven"
- "leverage my skills"
- "seamlessly"
- "delve"
- "furthermore"

Do not substitute one corporate cliche for another. Do not use excessive em
dashes. Do not use inflated adjectives to make ordinary experience sound
impressive.

### Do not summarize the resume

A cover letter is not a prose version of the resume. Assume the employer
already has the resume.

Instead, identify the 2-3 pieces of experience most relevant to what this
particular employer needs and build the letter around those. Explain
connections that are not obvious from the resume.

A strong paragraph should usually answer some version of "why does this
experience matter for this job?" rather than merely "what have I done?"

### Start with substance

Do not begin with "I am writing to apply for the [position] at [company]."
They already know why they are reading the letter.

Start with something more meaningful: a connection to the work, a
particularly relevant piece of experience, or a concise explanation of why
this role makes sense. The opening should still feel natural. Do not
manufacture a dramatic hook.

### Match the actual job

Read the job posting closely before drafting. Identify:

1. What problems they appear to need this person to solve.
2. What capabilities they emphasize repeatedly.
3. Which parts of Matt's background provide the strongest evidence for those
   capabilities.
4. What might make his background unusual or useful compared with a
   conventional candidate.

Prioritize those connections. Do not try to address every bullet point in
the posting.

### Do not invent anything

Never fabricate experience, accomplishments, technologies, responsibilities,
metrics, motivations, personal connections to the company, or enthusiasm
that is not supported by information Matt provided.

If the available information does not establish something, either omit it or
state it modestly. Do not turn "I have some experience with X" into "I have
extensive expertise in X."

### Calibrate confidence carefully

Present the experience positively, but do not oversell it. Prefer concrete
evidence over adjectives.

Prefer:

> My systems coursework gave me experience working directly in C and
> thinking about memory, processes, and lower-level behavior.

over:

> I possess deep expertise in systems programming and low-level
> architecture.

### Keep the background coherent

Matt's experience spans technical work, school, hospitality/service work,
community involvement, and other areas. Do not treat nontechnical work as
irrelevant just because the role is technical.

When appropriate, use it to demonstrate working calmly under pressure,
communicating with many kinds of people, collaboration, troubleshooting,
reliability, learning quickly, dealing with ambiguity, or taking ownership.

But do not force those connections when they are not relevant.

### Avoid fake intimacy with the employer

Do not write as though Matt has a deep emotional connection to a company
simply because he is applying there.

Bad: "Your mission has long deeply resonated with me."

Better: "I'm particularly interested in the way this role combines X and Y."

Only mention a company's mission, product, culture, or community impact when
there is something specific and defensible to say about it.

### Paragraph structure

A typical letter should be roughly 300-450 words, unless the application
suggests otherwise. Usually aim for a short substantive opening, 2-3 body
paragraphs, and a short closing.

Paragraphs should have distinct purposes rather than repeating the same
claim in different language. Do not force a five-paragraph essay structure.

### Closing

Keep the ending simple. Do not end with several sentences of ceremonial
gratitude and enthusiasm. This level of formality is appropriate:

> I'd be glad to talk more about how my experience could fit the role.
> Thanks for taking the time to consider my application.

Adapt naturally rather than repeating that exact wording every time.

### Editing test

Before returning a final cover letter, silently review it and ask:

1. Could this letter have been written for 100 other applicants? If yes,
   make it more specific.
2. Does any sentence merely restate something already obvious from the
   resume? If yes, improve it or remove it.
3. Does anything sound like LinkedIn, HR, or AI-generated prose? Rewrite it
   in plainer language.
4. Am I claiming more than the evidence supports? Tone it down.
5. Does the letter explain why this person's experience fits this particular
   job? If not, strengthen that connection.
6. Would a normal person plausibly say these sentences aloud? If not,
   rewrite them.

### When source material is available

When the repo contains a resume, job description, previous cover letters,
application notes, or answers Matt has personally written, treat his own
writing as the strongest source for his voice.

Study recurring features such as sentence length, vocabulary, level of
formality, humor or understatement, how directly he makes claims, and how he
describes his own accomplishments. Imitate those characteristics without
copying awkward wording verbatim.

Previous AI-generated cover letters should NOT automatically be treated as
examples of his voice unless he has explicitly marked them as approved.

### Default goal

The final result should make the reader think: "This person understands what
we're looking for, has a believable reason they could do the work, and
sounds like someone I could actually talk to."

It should not make the reader think: "This is a beautifully written cover
letter."

The writing exists to make the candidate legible, specific, and memorable,
not to call attention to itself.

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
