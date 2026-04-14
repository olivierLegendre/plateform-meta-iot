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
