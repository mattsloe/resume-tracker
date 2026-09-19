# Build And Verify Artifacts

Use this reference only when source documents changed or the user asks for a build or layout check.

## Build

- Use `resume/scripts/build.sh` for Markdown resumes.
- Compile Typst cover letters through the repository's existing path.
- Produce PDFs as submission artifacts unless another format is explicitly requested.
- Do not commit raster previews; they are temporary verification files.

## Visual Verification

After a PDF changes, render it to a scratch directory outside the repository and inspect the pixels. Check page size with `pdfinfo`; resumes should normally be US Letter (`612 x 792 pts`). Text extraction alone cannot verify layout.

```bash
pdftoppm -png -r 100 resume/exports/<file>.pdf "$SCRATCH_DIR"/preview
pdfinfo resume/exports/<file>.pdf
```

Check page count, clipping, crowding, unexpected page breaks, alignment, and readable spacing. Rebuild after corrections. Do not rerun visual verification when no PDF changed unless the user asks.

Record validated PDF paths and the resulting phase in `application_state.md`.
