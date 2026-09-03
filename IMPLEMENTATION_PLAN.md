# Implementation Plan: Schematron Documentation & Automation

This plan implements the approach described in `DOCUMENTATION_APPROACH.md`. Each step builds on the previous one.

## Step 1: Build the rules extraction script

**Where:** `espd-validation-schematron/scripts/`  
**What:** A Node.js script that parses all `.sch` files and extracts each `<assert>` into a structured register (CSV + AsciiDoc).  
**Why first:** This is the foundation — everything downstream (docs page, CI, reviews) consumes its output.  

**Outputs:**
- `output/business-rules-register.csv` — machine-readable, for tooling consumers
- `output/business-rules-register.adoc` — AsciiDoc table, for inclusion in espd-docs

**Columns extracted per rule:**
- Rule ID (`@id`)
- Severity (`@flag` or `@role`)
- Scope (Request / Response / Common — derived from source file path)
- Context (from parent `<rule context="...">`)
- Description (text content of `<assert>`)
- Source File (relative path to `.sch`)

---

## Step 2: Generate the register outputs

**Where:** `espd-validation-schematron/output/`  
**What:** Run the script to produce the initial register files.  
**Why:** Proves the script works and gives the first complete inventory of what the Schematron actually enforces.

**Validation:** Compare rule IDs found to those referenced in `espd-docs/modules/technical/pages/tech_busrules.adoc` to identify gaps or orphaned rules.

---

## Step 3: Create the new docs page in espd-docs

**Where:** `espd-docs/modules/technical/`  
**What:**
1. Copy `output/business-rules-register.adoc` to `espd-docs/modules/technical/partials/business-rules-register.adoc`
2. Create `espd-docs/modules/technical/pages/tech_rules_reference.adoc` that includes the partial
3. Add navigation entry in `espd-docs/modules/ROOT/nav.adoc`

**Why:** Makes the register immediately visible on the published docs site.

---

## Step 4: Add standardized headers to `.sch` files

**Where:** `espd-validation-schematron/common/sch/`, `ESPDRequest/sch/`, `ESPDResponse/sch/`  
**What:** Add structured comment headers to each `.sch` file:

```xml
<!--
  File: 03-ESPD-req-criterion-br.sch
  Scope: ESPD Request only
  Version: 5.0.0
  Maintenance: Manual
  Dependencies: ESPD-criterion.xml (from ESPD-EDM)
  Rules: BR-REQ-30, BR-REQ-40, BR-LOT-40, BR-LOT-41
-->
```

**Why:** Improves developer experience and allows the extraction script to populate the "Scope" column automatically from structured metadata (not just file path heuristics).

---

## Step 5: Create initial unit test fixtures

**Where:** `espd-validation-schematron/tests/`  
**What:** Start with the highest-value rules:
- `BR-REQ-30` (mandatory exclusion criteria)
- `BR-TCR-01-02` (response→property cross-reference)
- `BR-TCR-06` (ONTRUE conditional sub-groups)
- `BR-LOT-40` / `BR-LOT-41` (lot assignment structure)

Each rule gets one passing and one failing XML fixture:
- `tests/BR-REQ-30_pass.xml`
- `tests/BR-REQ-30_fail.xml`

**Why:** Validates the rules work as expected and serves as living documentation.

---

## Future Steps (not yet planned in detail)

- **Integrate extraction into `espd-schematron.bat`/`.sh`** — so the register is regenerated every time the pipeline runs.
- **Add CI check** — verify no `.sch` assert lacks an `@id` attribute.
- **Add `<diagnostics>` to complex rules** — extended fix guidance for structural/cross-reference rules.
- **Rework `tech_busrules.adoc`** — compress the 36 test-case tables into a single matrix, per the analysis in `espd-docs/BUSINESS_RULES_PAGE_ANALYSIS.md`.
