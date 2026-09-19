# Claude Code

Read `AGENTS.md` for shared repository rules.

Project skills are available through `.claude/skills/` as `/create-job-leads`, `/job-picker`, and `/job-application`. Those directories link to the canonical implementations in `.agents/skills/`.

Load only the selected skill and the references it routes to. Do not preload `resume/README.md` or `resume/master_resume.md` unless the active phase needs them.
