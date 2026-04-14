# Presentation — Agent Instructions

> Extends [agents.md](../agents.md). Apply when converting Markdown reports into stakeholder-ready documents
> (DOCX/PDF) using a reusable Ramery template.

---

## Mission

- Take one or more `.md` source files and produce polished `DOCX` and/or `PDF` outputs.
- Apply the agreed template consistently across reports.
- Improve readability and layout without changing technical meaning.

## Scope (and Non-Scope)

In scope:
- document structuring and visual consistency,
- export workflow (`.md` -> `.docx` / `.pdf`),
- template setup and reuse,
- formatting quality control.

Out of scope unless explicitly requested:
- changing technical conclusions,
- adding new research claims,
- rewriting strategy content from scratch.

## Input Contract

Required inputs per run:
1. source file(s) path,
2. target format (`docx`, `pdf`, or both),
3. template profile (default or named variant),
4. language (`fr` by default).

Optional inputs:
1. cover/title metadata,
2. logo/branding assets,
3. page style constraints (A4, margins, footer),
4. versioning fields (date, author, status).

## Output Contract

For each source markdown file, produce:
1. formatted `DOCX` and/or `PDF`,
2. optional normalized markdown (if structure cleanup was required),
3. a short conversion report listing:
- applied template,
- generated files,
- manual fixes still recommended.

## Formatting Rules

- Preserve source meaning and evidence traceability.
- Enforce consistent heading hierarchy.
- Add or refresh table of contents when possible.
- Normalize tables for readability in office formats.
- Keep links, dates, and references visible.
- Use page-ready structure: title block, sections, conclusion, references.

## Default Normalization Policy (Memorized)

Apply these defaults unless the user explicitly overrides them:

1. Do not edit the original source report by default.
2. Create or update a corrected working file (for example `*-corrige.md`) when structural cleanup is needed.
3. Keep technical meaning unchanged; only improve structure and readability.

### Structure and Numbering

1. Ensure numeric hierarchy is visually correct:
- section `1` and subsection `1.1` must be different heading levels.
- same rule for all numbered sections (for example `2` vs `2.1` / `2.2`).
2. Prefer sentence-style headings (not Title Case on every word) unless required by an existing standard.
3. For long reports, insert macro blocks to improve navigation:
- `A. Contexte et perimetre`
- `B. Partenaires et options d'integration`
- `C. Gouvernance, risques et cadrage de decision`
- `D. Sources et journaux de decision fournisseurs`
- `E. Matrices de capacites et strategie hybride`
- `F. Annexes techniques et comparaisons de reference`

### Lists

1. Normalize all list-like content into real Markdown lists (not inline or run-on text).
2. When an item ends with `:`, nested bullets under that item should be indented as sub-items.
3. Keep list spacing consistent so HTML/PDF rendering is stable.

### References and Links

1. Keep references clickable using Markdown links.
2. When a label has extra clarification in parentheses, only the main label should be clickable.
3. Keep parenthetical precision text outside the link when requested.

## HTML Rendering Defaults

Use CSS-driven styling for hierarchy and visual separation:

1. Macro block headings use a reusable `.bloc` class (not hardcoded id selectors).
2. `.bloc` applies the blue underline style for A/B/C/D/E/F blocks.
3. Subsections (`h3`) use visible indentation + left border to separate levels.

## Style Profile

Single active profile:

1. `strong` (selected baseline for management reports).

Default stylesheet path:
- `docs/presentations/ramery-report.css`.

## Template Rules

- Use one shared Ramery template as the default baseline.
- Keep style tokens centralized (fonts, colors, heading levels, spacing).
- Do not hardcode per-document styles when a template token exists.
- Maintain compatibility for both DOCX and PDF exports.

## Quality Checklist Before Delivery

- Exported file opens correctly in standard office tools.
- No broken headings, tables, or clipped sections.
- Pagination and section breaks are readable.
- Acronyms and labels are consistent.
- Final outputs are suitable for management review without markdown knowledge.
- Heading hierarchy is validated before export (`n` vs `n.m` must not share the same heading level).

## Export Behavior

1. For HTML export with heading classes (for example `.bloc`), use:
- `pandoc --from markdown --to html5 --standalone ...`
2. Avoid `--from gfm` when class attributes must be preserved.
3. Regenerate target outputs after any correction pass so source and export stay aligned.
4. For PDF footer logo + page numbering, use a patched Qt build of `wkhtmltopdf` and `--footer-html` with the Ramery footer template.
5. Run a heading-level sanity check before export on numbered headings:
- sections like `2.` should be `##`,
- subsections like `2.1` should be `###`,
- reject/normalize when `2` and `2.1` are both mapped to the same Markdown heading level.
