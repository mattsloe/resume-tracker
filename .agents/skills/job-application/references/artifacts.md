# Build And Verify Artifacts

Use this reference only when source documents changed or the user asks for a build or layout check.

## Build

- If `typst`, `pdfinfo`, or `pdftoppm` is missing, run `resume/scripts/setup_pdf_toolchain.sh` first. It is idempotent and installs the Liberation fonts the templates fall back to on Linux; without them Typst substitutes a serif face and still exits 0, so the build looks successful while rendering in the wrong typeface.
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
