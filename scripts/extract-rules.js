/**
 * extract-rules.js
 *
 * Parses all Schematron (.sch) files in the espd-validation-schematron repository
 * and extracts every <assert> into a structured business rules register.
 *
 * Outputs:
 *   - ../output/business-rules-register.csv   (machine-readable)
 *   - ../output/business-rules-register.adoc  (AsciiDoc table for espd-docs)
 *   - ../output/business-rules-register.json  (structured JSON)
 *
 * Usage:
 *   cd scripts
 *   npm install
 *   npm run extract-rules
 */

import { readFileSync, writeFileSync, mkdirSync, readdirSync, statSync } from 'fs';
import { join, relative, basename, dirname } from 'path';
import { XMLParser } from 'fast-xml-parser';

// ---------------------------------------------------------------------------
// Configuration
// ---------------------------------------------------------------------------

const ROOT_DIR = join(dirname(new URL(import.meta.url).pathname.replace(/^\/([A-Z]:)/, '$1')), '..');
const OUTPUT_DIR = join(ROOT_DIR, 'output');

// Directories containing .sch source files (relative to ROOT_DIR)
const SCH_DIRS = [
  'common/sch',
  'ESPDRequest/sch',
  'ESPDResponse/sch',
];

// ---------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------

/**
 * Parse the standardized header comment block from a .sch file.
 * Returns an object with keys: file, scope, version, maintenance, dependencies, rules, description.
 * Returns null if no structured header is found.
 */
function parseHeader(xml) {
  const headerMatch = xml.match(/<!--\s*([\s\S]*?)-->/);
  if (!headerMatch) return null;

  const block = headerMatch[1];
  const result = {};

  const fields = ['File', 'Scope', 'Version', 'Maintenance', 'Dependencies', 'Rules', 'Description'];
  for (const field of fields) {
    const re = new RegExp(`^\\s*${field}:\\s*(.+)`, 'mi');
    const m = block.match(re);
    if (m) {
      // For multi-line fields (like Rules), capture continuation lines
      const startIdx = block.indexOf(m[0]) + m[0].length;
      let value = m[1].trim();
      // Check for continuation lines (indented lines following the match)
      const remaining = block.slice(startIdx);
      const continuation = remaining.match(/^((?:\s{9,}.+\n?)*)/);
      if (continuation && continuation[1]) {
        value += ' ' + continuation[1].replace(/\s+/g, ' ').trim();
      }
      result[field.toLowerCase()] = value;
    }
  }

  return Object.keys(result).length > 0 ? result : null;
}

/**
 * Determine scope (Request / Response / Common) from the file header or path.
 */
function inferScope(filePath, header) {
  // Prefer header metadata if available
  if (header && header.scope) {
    const s = header.scope.toLowerCase();
    if (s.includes('request') && !s.includes('response')) return 'Request';
    if (s.includes('response') && !s.includes('request')) return 'Response';
    if (s.includes('common') || (s.includes('request') && s.includes('response'))) return 'Common';
  }
  // Fallback to path heuristic
  if (filePath.includes('ESPDRequest')) return 'Request';
  if (filePath.includes('ESPDResponse')) return 'Response';
  return 'Common';
}

/**
 * Infer a category from the filename numbering convention.
 */
function inferCategory(filename) {
  if (filename.startsWith('01-')) return 'Code list';
  if (filename.startsWith('02-')) return 'Cardinality';
  if (filename.startsWith('03-')) return 'Criterion';
  if (filename.startsWith('04-')) return 'Other';
  if (filename.startsWith('05-')) return 'Specific';
  return 'Unknown';
}

/**
 * Recursively find all .sch files in a directory.
 */
function findSchFiles(dir) {
  const results = [];
  for (const entry of readdirSync(dir)) {
    const fullPath = join(dir, entry);
    const stat = statSync(fullPath);
    if (stat.isDirectory()) {
      results.push(...findSchFiles(fullPath));
    } else if (entry.endsWith('.sch')) {
      results.push(fullPath);
    }
  }
  return results;
}

/**
 * Clean assertion message text: collapse whitespace, remove value-of placeholders.
 */
function cleanMessage(text) {
  if (!text) return '';
  // Handle case where text is an object (mixed content with value-of elements)
  if (typeof text === 'object') {
    if (Array.isArray(text)) {
      return text.map(t => typeof t === 'string' ? t : '').join(' ').replace(/\s+/g, ' ').trim();
    }
    // Extract #text if present
    if (text['#text']) {
      return String(text['#text']).replace(/\s+/g, ' ').trim();
    }
    return '';
  }
  return String(text).replace(/\s+/g, ' ').trim();
}

/**
 * Extract the context attribute from the rule's @context.
 */
function cleanContext(ctx) {
  if (!ctx) return '';
  return String(ctx).replace(/\s+/g, ' ').trim();
}

// ---------------------------------------------------------------------------
// Main extraction logic
// ---------------------------------------------------------------------------

function extractRulesFromFile(filePath) {
  const xml = readFileSync(filePath, 'utf-8');
  const relPath = relative(ROOT_DIR, filePath).replace(/\\/g, '/');
  const filename = basename(filePath);
  const header = parseHeader(xml);
  const scope = inferScope(relPath, header);
  const category = inferCategory(filename);

  const parser = new XMLParser({
    ignoreAttributes: false,
    attributeNamePrefix: '@_',
    textNodeName: '#text',
    isArray: (name) => ['rule', 'assert', 'pattern'].includes(name),
    removeNSPrefix: true,
  });

  let parsed;
  try {
    parsed = parser.parse(xml);
  } catch (e) {
    console.warn(`  WARNING: Could not parse ${relPath}: ${e.message}`);
    return [];
  }

  const rules = [];

  // Navigate: schema > pattern > rule > assert
  const schema = parsed.schema;
  if (!schema) return [];

  const patterns = Array.isArray(schema.pattern) ? schema.pattern : (schema.pattern ? [schema.pattern] : []);

  for (const pattern of patterns) {
    const patternRules = Array.isArray(pattern.rule) ? pattern.rule : (pattern.rule ? [pattern.rule] : []);

    for (const rule of patternRules) {
      const context = rule['@_context'] || '';
      const asserts = Array.isArray(rule.assert) ? rule.assert : (rule.assert ? [rule.assert] : []);

      for (const assert of asserts) {
        const id = assert['@_id'] || '';
        const flag = assert['@_flag'] || assert['@_role'] || '';
        const message = cleanMessage(assert['#text'] || assert);

        if (!id) continue; // Skip asserts without an ID

        rules.push({
          id,
          severity: flag,
          scope,
          category,
          context: cleanContext(context),
          description: message,
          sourceFile: relPath,
        });
      }
    }
  }

  return rules;
}

function extractAllRules() {
  const allRules = [];

  for (const schDir of SCH_DIRS) {
    const absDir = join(ROOT_DIR, schDir);
    let files;
    try {
      files = findSchFiles(absDir);
    } catch (e) {
      console.warn(`  WARNING: Directory not found: ${schDir}`);
      continue;
    }

    for (const file of files) {
      const relPath = relative(ROOT_DIR, file).replace(/\\/g, '/');
      console.log(`  Parsing: ${relPath}`);
      const rules = extractRulesFromFile(file);
      allRules.push(...rules);
    }
  }

  // Sort by ID for stable output
  allRules.sort((a, b) => a.id.localeCompare(b.id));
  return allRules;
}

// ---------------------------------------------------------------------------
// Output formatters
// ---------------------------------------------------------------------------

function toCSV(rules) {
  const header = 'Rule ID,Severity,Scope,Category,Context,Description,Source File';
  const rows = rules.map(r => {
    const escape = (s) => `"${s.replace(/"/g, '""')}"`;
    return [
      escape(r.id),
      escape(r.severity),
      escape(r.scope),
      escape(r.category),
      escape(r.context),
      escape(r.description),
      escape(r.sourceFile),
    ].join(',');
  });
  return [header, ...rows].join('\n');
}

function toAsciiDoc(rules) {
  const lines = [];
  lines.push('// Auto-generated by scripts/extract-rules.js — do not edit manually');
  lines.push('// Regenerate with: cd scripts && npm run extract-rules');
  lines.push('');
  lines.push(`// Total rules: ${rules.length}`);
  lines.push(`// Generated: ${new Date().toISOString().split('T')[0]}`);
  lines.push('');
  lines.push('[cols="2,1,1,1,4,3",options="header"]');
  lines.push('|===');
  lines.push('| Rule ID | Severity | Scope | Category | Description | Source File');
  lines.push('');

  for (const r of rules) {
    // Escape pipe characters in descriptions
    const desc = r.description.replace(/\|/g, '\\|');
    const ctx = r.context.replace(/\|/g, '\\|');
    lines.push(`| ${r.id}`);
    lines.push(`| ${r.severity}`);
    lines.push(`| ${r.scope}`);
    lines.push(`| ${r.category}`);
    lines.push(`| ${desc}`);
    lines.push(`| ${r.sourceFile}`);
    lines.push('');
  }

  lines.push('|===');
  return lines.join('\n');
}

function toJSON(rules) {
  return JSON.stringify({ generated: new Date().toISOString(), totalRules: rules.length, rules }, null, 2);
}

// ---------------------------------------------------------------------------
// Main
// ---------------------------------------------------------------------------

console.log('Extracting business rules from Schematron files...');
console.log(`Root: ${ROOT_DIR}`);
console.log('');

const rules = extractAllRules();

console.log('');
console.log(`Total rules extracted: ${rules.length}`);

// Ensure output directory exists
mkdirSync(OUTPUT_DIR, { recursive: true });

// Write outputs
const csvPath = join(OUTPUT_DIR, 'business-rules-register.csv');
writeFileSync(csvPath, toCSV(rules), 'utf-8');
console.log(`  Written: ${relative(ROOT_DIR, csvPath)}`);

const adocPath = join(OUTPUT_DIR, 'business-rules-register.adoc');
writeFileSync(adocPath, toAsciiDoc(rules), 'utf-8');
console.log(`  Written: ${relative(ROOT_DIR, adocPath)}`);

const jsonPath = join(OUTPUT_DIR, 'business-rules-register.json');
writeFileSync(jsonPath, toJSON(rules), 'utf-8');
console.log(`  Written: ${relative(ROOT_DIR, jsonPath)}`);

console.log('');
console.log('Done.');
