# Unit Test Fixtures

This folder contains minimal XML test fixtures for individual Schematron business rules. Each rule gets two files:

- `{RULE-ID}_pass.xml` — a minimal document that **satisfies** the rule (validation should produce no error for this rule)
- `{RULE-ID}_fail.xml` — a minimal document that **violates** the rule (validation should fire the assertion)

## Naming Convention

```
BR-REQ-30_pass.xml    ← passes rule BR-REQ-30
BR-REQ-30_fail.xml    ← triggers rule BR-REQ-30
```

## Design Principles

- **Minimal** — only the elements relevant to the rule under test are included. Other elements are omitted or use placeholder values.
- **Self-contained** — each fixture is a complete XML document (valid enough to be parsed), not a fragment.
- **One rule per file** — a fixture targets exactly one rule. It may incidentally pass/fail other rules, but its purpose is to test the named rule.

## How to Use

These fixtures can be validated against the compiled XSL files using Saxon:

```bash
java -jar common/lib/saxon-he-12.5.jar -s:tests/BR-REQ-30_pass.xml -xsl:ESPDRequest/xsl/03-ESPD-req-criterion-br.xsl
```

A future CI step will automate running all fixtures and checking that pass files produce no errors for the target rule, and fail files produce exactly the expected error.

## Coverage

Currently covers:
- `BR-REQ-30` — Mandatory exclusion criteria (8 types must be present)
- `BR-LOT-40` — Exclusion criteria cannot have lot references
- `BR-LOT-41` — Selection criteria must have lot references
- `BR-LOT-10` — ESPD Response must specify exactly one lot
