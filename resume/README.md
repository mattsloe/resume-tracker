# Resume Workflow

This is a lightweight, version-controlled resume system built around two ideas:

1. Markdown is the source of truth for everything you edit.
2. Typst handles the final visual polish for PDF exports.

The goal is fast iteration, clean Git history, and a structure that AI tools can safely edit without fighting a complex schema.

## Project Layout

```text
resume/
  README.md
  master_resume.md
  jobs/
    example_job/
      job_posting.md
      tailored_resume.md
  templates/
    resume.typ
  scripts/
    build.sh
  exports/
  prompts/
    tailor_resume.md
    rewrite_bullets.md
    ats_keyword_check.md
```

## Install Typst

Typst is required for PDF export.

On macOS with Homebrew:

```bash
brew install typst
```

Other install options are available in the official Typst compiler docs:

- [Typst install options](https://typst.app/open-source/)
- [Typst command-line PDF export](https://typst.app/docs/reference/pdf/)

## Resume Format

The build script expects a small, readable Markdown convention.

### Top of file

```md
# Your Name
Your target headline
City, ST · email@example.com · linkedin.com/in/you · portfolio.com
```

### Supported sections

Use these section headings when you want the script to render them:

- `## Summary`
- `## Experience`
- `## Projects`
- `## Skills`
- `## Education`

### Entry format

For `Experience` and `Education`, each entry should look like this:

```md
### Company or School | Role or Degree | Location | Dates
- Bullet
- Bullet
```

For `Projects`, use:

```md
### Project Name | Short descriptor | Dates
- Bullet
- Bullet
```

For `Skills`, keep each line simple:

```md
Product: Roadmapping; Stakeholder communication; Discovery
Tools: Figma; SQL; Notion; Excel
```

This format is intentionally small and predictable so humans and AI tools can edit it quickly without introducing fragile metadata.

## Export a PDF

From the `resume/` directory:

```bash
./scripts/build.sh master_resume.md
./scripts/build.sh jobs/example_job/tailored_resume.md
```

Exports are written to `exports/`.

Examples:

- `master_resume.md` -> `exports/master_resume.pdf`
- `jobs/example_job/tailored_resume.md` -> `exports/example_job_resume.pdf`

You can also provide a custom output name:

```bash
./scripts/build.sh jobs/example_job/tailored_resume.md acme_senior_pm
```

That creates `exports/acme_senior_pm.pdf`.

## Add a New Job Folder

1. Copy the example folder.
2. Rename it to something simple and grep-friendly like `jobs/acme_product_manager/`.
3. Paste the job description into `job_posting.md`.
4. Duplicate or derive a new `tailored_resume.md` from `master_resume.md`.
5. Trim to the most relevant bullets and wording.
6. Run the build script to generate the PDF.

Example:

```bash
mkdir -p jobs/acme_product_manager
cp jobs/example_job/job_posting.md jobs/acme_product_manager/job_posting.md
cp jobs/example_job/tailored_resume.md jobs/acme_product_manager/tailored_resume.md
```

## Git Workflow

Keep the source files under version control and treat each application as a small iteration branch.

Suggested patterns:

- Keep `master_resume.md` updated on your main branch.
- Create one branch per application, such as `resume/acme-product-manager`.
- Commit often when you meaningfully change wording, emphasis, or scope.
- Optionally commit exported PDFs only when you want a durable snapshot of the exact version you submitted.

Examples:

```bash
git checkout -b resume/acme-product-manager
git add master_resume.md jobs/acme_product_manager/tailored_resume.md
git commit -m "Tailor resume for Acme product manager role"
```

Helpful commit boundaries:

- one commit for job analysis
- one commit for resume tailoring
- one commit for final pre-submit polish

## Suggested AI Workflows

### 1. Tailor from a job posting

Give an AI tool:

- `master_resume.md`
- `jobs/<company>/job_posting.md`
- `prompts/tailor_resume.md`

Ask it to draft `jobs/<company>/tailored_resume.md` using the same Markdown structure.

### 2. Rewrite bullets without sounding fake

Use:

- `master_resume.md`
- `prompts/rewrite_bullets.md`

Ask for 3 to 5 honest variants of a specific bullet, then choose the one that still sounds like you.

### 3. ATS keyword pass

Use:

- `jobs/<company>/job_posting.md`
- `jobs/<company>/tailored_resume.md`
- `prompts/ats_keyword_check.md`

Ask for missing keywords, weak phrasing, and truthful insertion opportunities.

### 4. Industry tone adjustment

Ask the AI to keep the facts fixed while shifting tone for:

- startup
- enterprise
- design-forward product team
- operations-heavy role
- mission-driven nonprofit

The prompts are written to protect specificity and authentic voice over generic corporate filler.

## Editing Guidance

- Treat `master_resume.md` as the long-form inventory.
- Put extra bullet variants there instead of trying to remember them later.
- Keep tailored resumes shorter and role-specific.
- Prefer concrete verbs, scope, and outcomes over abstract buzzwords.
- Never let AI invent metrics, tools, ownership, or achievements.

## Notes

- This v1 intentionally avoids YAML, JSON, databases, and heavy automation.
- The build step is a thin bridge from Markdown into Typst.
- If you later want richer automation, you can add it without changing the basic source files.
