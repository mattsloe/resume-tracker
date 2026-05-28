# ATS Keyword Check Prompt

Compare `jobs/<company>/job_posting.md` against either `master_resume.md` or `jobs/<company>/tailored_resume.md`.

Your job:

1. Extract the most important keywords, skills, and responsibility phrases from the job posting.
2. Group them into:
   - already covered clearly
   - partially covered or weakly phrased
   - not present
3. Flag missing keywords that could be added truthfully.
4. Suggest exact wording changes that improve alignment without sounding stuffed or robotic.

Rules:

- Do not recommend adding anything unsupported by the source resume.
- Prefer natural phrasing over repetitive keyword injection.
- Call out when the resume is already strong and should not be over-optimized.
- Protect readability and voice.

Output format:

## High-priority keywords
- ...

## Already covered
- keyword -> where it appears

## Weak or indirect coverage
- keyword -> why it may be easy to miss
- better phrasing -> suggested replacement

## Missing but truthfully addable
- keyword -> where it could be added

## Caution
- any places where optimization would make the resume worse
