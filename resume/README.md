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
    application_state.md
    resume.typ
  scripts/
    build.sh
  exports/
  prompts/
    rewrite_bullets.md
    legacy/
```

## Install Typst

Typst is required for PDF export.

On macOS with Homebrew:

```bash
brew install typst poppler
```

On a fresh Linux container — Claude Code on the web, CI, a new VM — run:

```bash
resume/scripts/setup_pdf_toolchain.sh
```

That installs Typst, `poppler-utils` for the layout checks, and the Liberation
fonts. The fonts are not optional: the templates ask for Helvetica Neue, Arial,
Charter, and Times New Roman, none of which exist on Linux, and without a
fallback installed Typst silently substitutes a serif face and still exits 0 —
so the build reports success while rendering in the wrong typeface. The script
is safe to re-run and leaves anything already installed alone.

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
- separate commits for any reusable `master_resume.md` improvements that should be cherry-picked back to `main`

## Application Workflow

For an active application, invoke the shared skill using your agent's syntax:

```text
Codex:        $job-application <job link or company + role>
Claude Code: /job-application <job link or company + role>
Cursor:      /job-application <job link or company + role>
```

The shared `job-application` skill handles intake, Notion tracking, branch setup, strategy, drafting, builds, and submission. Codex and Cursor discover the canonical skills in `.agents/skills/`; Claude Code uses links under `.claude/skills/`. Each job folder includes `application_state.md`, copied from `templates/application_state.md`, so later turns can resume from `next_action` without reconstructing the workflow.

Use `create-job-leads` for research before choosing a role, and `job-picker` to choose among existing Notion cards, with the same `$name` versus `/name` convention.

After changing shared agent instructions or skills, validate cross-agent discovery from the repository root:

```bash
resume/scripts/validate_agent_workflows.sh
```

## Suggested AI Workflows

### Rewrite bullets without sounding fake

Use:

- `master_resume.md`
- `prompts/rewrite_bullets.md`

Ask for 3 to 5 honest variants of a specific bullet, then choose the one that still sounds like you.

### Industry tone adjustment

Ask the AI to keep the facts fixed while shifting tone for:

- startup
- enterprise
- design-forward product team
- operations-heavy role
- mission-driven nonprofit

The active prompt protects specificity and authentic voice. Superseded workflow prompts remain under `prompts/legacy/` for reference; the shared `job-application` skill replaces them.

## Editing Guidance

- Treat `master_resume.md` as the long-form inventory.
- Put extra bullet variants there instead of trying to remember them later.
- Keep tailored resumes shorter and role-specific.
- Prefer concrete verbs, scope, and outcomes over abstract buzzwords.
- Never let AI invent metrics, tools, ownership, or achievements.

## Style Notes

Learned from formatting passes on real applications — check these before
generating a tailored resume or cover letter.

### Cover letters

These are typography notes only. For what the letter should actually
say and how it should sound, follow "Cover Letter Voice" in `AGENTS.md`.

- Start from `templates/cover_letter.typ` and copy it into the job folder
  as `cover_letter.typ`, then replace the placeholders.
- Use `#set par(leading: 0.45em, spacing: 0.9em, justify: false)` at 11pt
  in a serif font (Charter/Times). An earlier template used
  `leading: 0.2em` with a manual hanging-indent `paragraph()` block —
  that reads as cramped, with wrapped lines running together. Plain
  paragraphs separated by a blank line, at the wider leading/spacing
  above, read cleanly.
- Keep the header simple: bold name, then a contact line underneath. No
  need to hand-roll date/recipient line-grouping helpers.

### Resumes (one page, for early-career/concise roles)

- `templates/resume.typ` renders a genuinely full one-pager comfortably: a
  3-4 line summary, 2-3 experience entries (2 bullets each), one Projects
  entry (2-3 bullets), a 3-4 line Skills block, and Education with a
  coursework bullet all fit with room to spare. If a real draft still
  doesn't fit at that density, trim low-signal content first — but see
  "ATS-targeted roles" below before cutting anything `strategy.md` flagged
  as required-qualification evidence.
- Don't restate the exact same phrase twice for no reason, but deliberate
  repetition of a truthful keyword across Education, Skills, and
  Experience/Projects is a feature for ATS matching, not a bug — see
  "ATS-targeted roles" below.

### Verify formatting with real screenshots, not text extraction

A text-extraction preview of a PDF (or a tool that returns "page 1 / page
2" text blocks) can look identical across two builds that are visually
very different, and can look fine even when the page size itself is
wrong. Two real bugs shipped for a while because of this:

1. Every resume this repo built was silently rendered on A4 (595x842pt)
   instead of the Letter size (8.5x11in) configured in the template,
   because `#set page(...)` inside an imported module doesn't apply to
   the importing document unless it's used as a show rule
   (`#show: page_style`, not a plain function call). Text extraction
   never surfaced this; `pdfinfo <file>.pdf` and a rendered screenshot
   did immediately.
2. entry_block's title/date row used `table()`, which is atomic and
   unbreakable — the whole entry would jump to the next page even with
   over half an inch of visible room left. This only showed up by
   actually rendering the page to an image and measuring where content
   stopped versus the true margin.

Before calling a layout question resolved (fits one page? spacing looks
right? nothing crowded?), render real pixels and look at them:

```bash
pdftoppm -png -r 100 resume/exports/<file>.pdf /tmp/preview
```

Then view `/tmp/preview-1.png` (etc.) directly, and cross-check the page
size with `pdfinfo resume/exports/<file>.pdf`. `poppler-utils` provides
both `pdftoppm` and `pdfinfo`; run `resume/scripts/setup_pdf_toolchain.sh`
if either is missing.

### ATS-targeted roles (technical screening, keyword-sensitive postings)

For a role that will run resumes through automated keyword screening
(most technical roles with a formal posting):

- Build `strategy.md` first (see the `job-application` skill) and pull its
  keyword list into Summary, Experience/Projects, and Skills verbatim
  where truthful — don't paraphrase away the posting's exact terms (e.g.
  write "relational database" if that's the posting's phrase, even
  alongside "SQL").
- Expand the most relevant Project or Experience entry to 2-3 bullets
  when it's carrying the bulk of the keyword match.
- If, after using the template at its real capacity (see above), a draft
  still doesn't fit one page, let Education (or another low-signal
  section) fall onto page two rather than deleting a required-
  qualification keyword to force one page.

## Notes

- This v1 intentionally avoids YAML, JSON, databases, and heavy automation.
- The build step is a thin bridge from Markdown into Typst.
- If you later want richer automation, you can add it without changing the basic source files.
