# Documentation Approach for ESPD Validation Schematron

This document describes best practices for documenting the Schematron business rules in this repository and defines where each documentation artifact should live across the ESPD repository landscape.

## Source Artifacts in This Repository

| Artifact Type | Location | Purpose | Maintained |
|---|---|---|---|
| **Schematron rules (`.sch`)** | `common/sch/`, `ESPDRequest/sch/`, `ESPDResponse/sch/` | Business rules expressed as XPath assertions | Mostly manual (except `01-ESPD-codelist-values.sch` which is generated) |
| **Code Value Association (`.cva`)** | `common/cva/01-ESPD-codelist-values.cva` | Maps XML elements/attributes to their allowed code lists | Manual |
| **Genericode code lists (`.gc`)** | `gc/` | Allowed values for each code list (country, currency, criterion types, etc.) | Copied from ESPD-EDM (sourced from EU Vocabularies) |
| **XSD schemas** | `common/xsd/`, `common/xsdrt/` | UBL 2.3/2.4 runtime schemas for structural XML validation | Copied from UBL distribution |
| **Criterion reference XML** | `ESPDRequest/xsl/ESPD-criterion.xml`, `ESPDResponse/xsl/ESPD-criterion.xml` | Canonical criterion structure from e-Certis used as lookup by Schematron | Copied from ESPD-EDM |
| **Criterion list XML** | `ESPDRequest/xsl/criterionList.xml`, `ESPDResponse/xsl/criterionList.xml` | Summary list of criteria for validation | Manual |
| **XSL transformations** | `common/xsl/` | Tooling to convert SCH→XSL and CVA→SCH | Rarely modified |
| **Base sample XML** | `common/xml/ESPD-Request-BASE.xml`, `ESPD-Response-BASE.xml` | Test fixtures used in validation pipeline | Manual / from ESPD Demo |
| **Generated XSL outputs** | `ESPDRequest/xsl/`, `ESPDResponse/xsl/` | Compiled validation stylesheets (product, not source) | Auto-generated |
| **Build scripts** | `espd-schematron.bat`, `espd-schematron.sh` | Orchestrates the generation pipeline | Manual |

---

## Best Practices for Documenting Schematron Projects

### 1. Business Rules Register (the cornerstone)

The single most valuable documentation artifact is a **tabular rules catalogue** — a flat, searchable list of every rule with metadata. This is what mature Schematron projects (Peppol, eForms/TED, NEMSIS, CEN) converge on:

| Column | Purpose |
|---|---|
| **Rule ID** | Unique identifier (e.g. `BR-TC-07`) |
| **Severity** | `fatal` / `warning` / `error` |
| **Scope** | Request, Response, or Both |
| **Context** (XPath) | Where the rule fires |
| **Assertion** (human-readable) | What it checks, in plain language |
| **Business Term reference** | Traceability to the data model (e.g. BT-10, BG-7) |
| **Source file** | Which `.sch` file contains it |
| **Category** | Code list, cardinality, criterion structure, cross-reference, etc. |

This register should be **auto-generated** from the `.sch` files via XSLT or a script, so it never drifts from the source.

### 2. Validation Layers Diagram

Document the **logical sequence** of validation stages. TED's eForms approach is a good model — they describe execution order as:

1. Required container elements present / forbidden ones absent
2. Required leaf elements present / forbidden ones absent
3. Code list value checks
4. Conditional presence/absence rules
5. Cross-field consistency checks
6. Dynamic rules (external data dependencies)

For ESPD this maps to the existing numbering convention:

- `01-*` — Code list values and attributes
- `02-*` — Cardinality constraints
- `03-*` — Criterion structure rules
- `04-*` — Other general business rules
- `05-*` — Role-specific and domain-specific rules

### 3. Unit Tests Per Rule (the Peppol approach)

In [peppol-bis-invoice-3](https://github.com/OpenPEPPOL/peppol-bis-invoice-3), OpenPEPPOL maintains a `rules/unit-UBL-PEPPOL/` folder with **one XML test file per rule ID**. Each file is structured like:

```xml
<testSet xmlns="http://difi.no/xsd/vefa/validator/1.0"
         configuration="peppolbis-en16931-base-3.0-ubl">
  <assert>
    <description>Verify calculation of line extension amount.</description>
    <scope>PEPPOL-EN16931-R120</scope>
  </assert>
  <test>
    <assert><success>PEPPOL-EN16931-R120</success></assert>
    <!-- minimal valid XML snippet -->
  </test>
  <test>
    <assert><error>PEPPOL-EN16931-R120</error></assert>
    <!-- minimal invalid XML snippet -->
  </test>
</testSet>
```

Key properties of this approach:

- Each test contains the **minimal** XML fragment needed to trigger or satisfy the rule
- Tests declare whether they expect `<success>` or `<error>`
- Tests are runnable in CI via the VEFA validator framework
- They serve as **living documentation** — read a test to understand what a rule does

### 4. Published Human-Readable Spec

Peppol publishes the rules as part of their BIS documentation using AsciiDoc, rendered into HTML/PDF. Key sections include:

- **Validation Principles** — explains the layering (syntax → EN16931 → Peppol CIUS → country rules)
- **Rules tables** — one table per category (general, country-specific) with columns: Rule ID, Context, Severity, Message
- **Code list tables** — which code lists are used where

For ESPD, the equivalent is the published documentation on [TED Developer Docs](https://docs.ted.europa.eu/ESPD-EDM/).

### 5. Traceability Matrix

Map each Schematron rule back to:

- The **requirement** it implements (e.g. Directive 2014/24/EU Article X, or ESPD-EDM v5.0.0 §3.2)
- The **data model element** it constrains
- The **test case** that verifies it

This closes the loop between legal requirements → data model → validation rules → tests.

### 6. Source vs. Generated Distinction

A clear manifest distinguishing:

- **Source of truth** — hand-maintained files you edit
- **Derived/generated** — outputs of the pipeline you never edit directly
- **External dependencies** — files copied from ESPD-EDM, UBL, EU Vocabularies

### 7. Per-File Header Documentation

Standardize headers in each `.sch` file:

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

### 8. Consider Schematron Phases

Like TED's eForms, group patterns by applicability (Request-only, Response-only, common) so validation can be scoped and execution time reduced for large documents.

---

## How Peppol Does It

The [OpenPEPPOL/peppol-bis-invoice-3](https://github.com/OpenPEPPOL/peppol-bis-invoice-3) repository structure:

```
rules/
├── sch/                          # Schematron source files
│   ├── PEPPOL-EN16931-UBL.sch   # Core Peppol rules for UBL
│   ├── CEN-EN16931-UBL.sch      # CEN standard rules
│   └── PEPPOL-EN16931-CII.sch   # CII variant
├── unit-UBL-PEPPOL/             # Unit tests: one file per Peppol rule
│   ├── PEPPOL-EN16931-R001.xml
│   ├── PEPPOL-EN16931-R002.xml
│   └── ...
├── unit-UBL-DK/                 # Country-specific unit tests (Denmark)
├── unit-UBL-SE/                 # Country-specific (Sweden)
├── examples/                    # Full valid example documents
└── national-examples/           # Per-country examples

guide/                           # AsciiDoc documentation source
├── transaction-spec/
│   ├── validation/
│   │   └── validation-principles.adoc
│   ├── codes/
│   └── annex/
└── national-rules/
    └── schematron.adoc

structure/                       # Syntax binding definitions
└── codelist/                    # Code list definitions (XML)
```

Key design decisions Peppol makes:

1. **Rules are namespaced** — `PEPPOL-EN16931-RXXX` for Peppol-layer rules, `BR-XX` for CEN rules, `XX-R-NNN` for country rules
2. **Each rule has exactly one test file** — trivial to verify a rule works in isolation
3. **Tests include both passing and failing cases** — know both what should pass AND what should fail
4. **Country rules are parametric** — triggered by supplier country code, kept in separate `.sch` includes
5. **Build produces validation artifacts** — `build.sh`/`.bat` compiles everything and runs all unit tests
6. **Documentation is co-located** — the AsciiDoc guide lives in the same repo and references the same rule IDs

---

## Where Each Part Should Live

Based on the [espd-docs DOCUMENTATION_GUIDELINES.md](https://github.com/OP-TED/espd-docs/blob/main/DOCUMENTATION_GUIDELINES.md) principles:

- Machine-processable artefacts → `ESPD-EDM`
- Human-readable explanations → `espd-docs`

### Distribution Across Repositories

| Documentation Artifact | Repository | Rationale |
|---|---|---|
| **Schematron source files** (`.sch`) | `espd-validation-schematron` | Source of truth, hand-maintained. Already here. |
| **Generated validation XSLs** | `ESPD-EDM/validation/` | Versioned release artefacts. Already copied per pipeline. |
| **Machine-readable rules register** (CSV/JSON) | `espd-validation-schematron` (generated) → copied to `ESPD-EDM/validation/` on release | Derived artefact from `.sch` files, belongs alongside compiled XSLs. |
| **Unit test fixtures** (pass/fail XML per rule) | `espd-validation-schematron` | Test infrastructure lives with the source. |
| **Human-readable rules documentation** (AsciiDoc) | `espd-docs/modules/technical/pages/` | Published narrative documentation. |
| **XSLT/script to extract rules register** | `espd-validation-schematron` | Tooling that runs as part of the build pipeline. |

### Integration Into espd-docs for Publication on TED Developer Docs

The `espd-docs` repository is an Antora component published to `https://docs.ted.europa.eu/ESPD-EDM/`. Integration approach:

#### Step 1: Generate an AsciiDoc-compatible rules table during the schematron build

Add a build step (XSLT or script) that produces a file like `business-rules-register.adoc`:

```asciidoc
[cols="1,1,1,3,2",options="header"]
|===
| Rule ID | Severity | Scope | Description | Source File

| BR-COM-10-01
| fatal
| Common
| TED CN ID must match pattern YYYY/S NNN-NNNNNN
| 04-ESPD-common-other-br.sch

| BR-REQ-30
| fatal
| Request
| 8 mandatory exclusion criteria types required
| 03-ESPD-req-criterion-br.sch

| ...
|===
```

#### Step 2: Copy the generated AsciiDoc partial to espd-docs

During the release process, copy the generated table to:

```
espd-docs/modules/technical/partials/business-rules-register.adoc
```

Using Antora's `partials` mechanism means the content can be included in multiple pages without duplication.

#### Step 3: Include it in the existing documentation pages

In `tech_busrules.adoc` or a new dedicated page like `tech_rules_reference.adoc`:

```asciidoc
== Business Rules Reference

The following table is auto-generated from the Schematron source files
in the link:https://github.com/OP-TED/espd-validation-schematron[espd-validation-schematron] repository.

\include::partial$business-rules-register.adoc[]
```

#### Step 4: Add navigation entry

In `espd-docs/modules/ROOT/nav.adoc`, under Technical Implementation:

```asciidoc
* xref:technical:tech_rules_reference.adoc[Business Rules Reference]
```

### Target Architecture

```
espd-validation-schematron/          ← SOURCE OF TRUTH
├── common/sch/*.sch                 (hand-maintained rules)
├── ESPDRequest/sch/*.sch            (hand-maintained rules)
├── ESPDResponse/sch/*.sch           (hand-maintained rules)
├── tests/                           (unit test XML fixtures per rule)       [NEW]
├── scripts/extract-rules.xsl       (generates register from .sch)          [NEW]
└── output/
    └── business-rules-register.adoc (generated AsciiDoc partial)           [NEW]

    ↓ release process copies to ↓

ESPD-EDM/validation/                 ← VERSIONED RELEASE ARTEFACTS
├── ESPDRequest/xsl/*.xsl            (compiled validators)
├── ESPDResponse/xsl/*.xsl
├── common/sch/*.sch
└── business-rules-register.csv      (machine-readable register)            [NEW]

    ↓ release process copies .adoc partial to ↓

espd-docs/                           ← PUBLISHED DOCUMENTATION
├── antora.yml
└── modules/technical/
    ├── pages/
    │   ├── tech_validation.adoc     (explains validation architecture)
    │   ├── tech_busrules.adoc       (explains rule categories & process)
    │   └── tech_rules_reference.adoc (includes the auto-generated table)  [NEW]
    └── partials/
        └── business-rules-register.adoc (auto-generated rules table)      [NEW]
```

### Key Design Decisions

1. **Generate, don't duplicate** — The rules table is extracted from `.sch` files, never manually maintained in espd-docs. This follows the guideline: "Avoid manually copying large technical tables when they can be generated from source artefacts."

2. **Partials over pages** — Using Antora `partials` lets you include the same register in multiple contexts (full reference page, per-category sub-tables) without drift.

3. **Tests stay with source** — Unit test fixtures live in `espd-validation-schematron` because they're tightly coupled to the `.sch` files they verify. They don't need to be published on the docs site.

4. **Machine-readable + human-readable outputs** — Generate both a `.csv`/`.json` (for tooling consumers, goes to ESPD-EDM) and an `.adoc` table (for docs site, goes to espd-docs partials).

5. **Existing pages absorb new content** — The existing `tech_validation.adoc` and `tech_busrules.adoc` pages describe the architecture and approach. The register is a reference appendix that supplements them.

---

## Recommended Roadmap

1. **Extract a rules register** — Write an XSLT or Python script to parse all `.sch` files and emit a Markdown/CSV table with rule ID, severity, context, message, file. This is cheap and immediately high-value.

2. **Add unit tests per rule** — Start with the 8 mandatory exclusion criteria rules and the cross-reference rules. Use Peppol's `<testSet>` format or plain XML files with a naming convention like `BR-REQ-30_pass.xml` / `BR-REQ-30_fail.xml`.

3. **Document the layer model** — A one-page diagram showing: XSD (structure) → Code list values (01-*) → Cardinality (02-*) → Criterion structure (03-*) → Other (04-*) → Specific/Role (05-*).

4. **Add a MANIFEST distinguishing source from generated** — Make explicit which files are hand-maintained vs. pipeline outputs.

5. **Consider Schematron phases** — Group patterns by applicability (Request-only, Response-only, common) so validation can be scoped.

---

## References

- [OpenPEPPOL/peppol-bis-invoice-3](https://github.com/OpenPEPPOL/peppol-bis-invoice-3) — Peppol BIS Billing 3.0 reference implementation
- [TED Developer Docs — Schematron files](https://docs.ted.europa.eu/eforms/latest/schematrons/index.html) — eForms validation architecture
- [espd-docs DOCUMENTATION_GUIDELINES.md](https://github.com/OP-TED/espd-docs) — Content ownership principles for ESPD documentation
- [ISO/IEC 19757-3](https://www.schematron.com/) — ISO Schematron standard
