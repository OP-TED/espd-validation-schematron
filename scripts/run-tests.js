/** Run Schematron unit-test fixtures through Saxon and inspect the SVRL. */
import { execSync } from 'child_process';
import { existsSync, readFileSync, readdirSync } from 'fs';
import { basename, dirname, extname, join } from 'path';
import { XMLParser } from 'fast-xml-parser';

const ROOT_DIR = join(dirname(new URL(import.meta.url).pathname.replace(/^\/([A-Z]:)/, '$1')), '..');
const TESTS_DIR = join(ROOT_DIR, 'tests');
const REGISTER_FILE = join(ROOT_DIR, 'output', 'business-rules-register.json');
const SAXON_JAR = join(ROOT_DIR, 'common', 'lib', 'saxon-he-12.5.jar');
const parser = new XMLParser({ ignoreAttributes: false, attributeNamePrefix: '@_', removeNSPrefix: true });

function shellQuote(value) {
  if (process.platform === 'win32') return `"${value.replace(/"/g, '""')}"`;
  return `'${value.replace(/'/g, `'"'"'`)}'`;
}

function documentType(testFile) {
  const document = parser.parse(readFileSync(testFile, 'utf8'));
  const rootName = Object.keys(document).find(key => !key.startsWith('?'));
  if (rootName === 'QualificationApplicationRequest') return 'ESPDRequest';
  if (rootName === 'QualificationApplicationResponse') return 'ESPDResponse';
  throw new Error(`Unsupported XML root element: ${rootName || '(none)'}`);
}

function xslFilesFor(ruleId, documentDirectory, rulesById) {
  const rules = rulesById.get(ruleId) || [];
  if (rules.length === 0) throw new Error(`Rule ${ruleId} is not present in the business-rules register`);
  const files = new Set();
  for (const rule of rules) {
    const sourceDirectory = rule.sourceFile.split('/')[0];
    if (sourceDirectory !== 'common' && sourceDirectory !== documentDirectory) continue;
    const xslName = `${basename(rule.sourceFile, extname(rule.sourceFile))}.xsl`;
    const xslFile = join(ROOT_DIR, documentDirectory, 'xsl', xslName);
    if (existsSync(xslFile)) files.add(xslFile);
  }
  if (files.size === 0) throw new Error(`No compiled ${documentDirectory} XSL found for rule ${ruleId}`);
  return [...files];
}

function failedAssertIds(svrl) {
  const ids = [];
  function visit(node, key = '') {
    if (key === 'failed-assert' && node && typeof node === 'object') {
      for (const assertion of Array.isArray(node) ? node : [node]) {
        if (assertion['@_id']) ids.push(String(assertion['@_id']));
      }
    }
    if (node && typeof node === 'object') {
      for (const [childKey, child] of Object.entries(node)) visit(child, childKey);
    }
  }
  visit(parser.parse(svrl));
  return ids;
}

function transform(testFile, xslFile) {
  const command = ['java', '-jar', shellQuote(SAXON_JAR), `-s:${shellQuote(testFile)}`, `-xsl:${shellQuote(xslFile)}`].join(' ');
  try {
    return execSync(command, { cwd: ROOT_DIR, encoding: 'utf8', stdio: ['ignore', 'pipe', 'pipe'], maxBuffer: 10 * 1024 * 1024 });
  } catch (error) {
    // Saxon can return non-zero even when stdout contains usable SVRL.
    const output = error.stdout?.toString() || '';
    if (output.trim()) return output;
    throw new Error(`Saxon produced no SVRL: ${error.stderr?.toString().trim() || error.message}`);
  }
}

function main() {
  const register = JSON.parse(readFileSync(REGISTER_FILE, 'utf8'));
  const rulesById = new Map();
  for (const rule of register.rules) {
    const matches = rulesById.get(rule.id) || [];
    matches.push(rule);
    rulesById.set(rule.id, matches);
  }
  const fixtures = readdirSync(TESTS_DIR).filter(file => /_(pass|fail)\.xml$/.test(file)).sort();
  let failures = 0;
  for (const fixture of fixtures) {
    const [, ruleId, expectation] = fixture.match(/^(.*)_(pass|fail)\.xml$/);
    const testFile = join(TESTS_DIR, fixture);
    try {
      const directory = documentType(testFile);
      const matchingXsls = xslFilesFor(ruleId, directory, rulesById).filter(
        xsl => failedAssertIds(transform(testFile, xsl)).includes(ruleId),
      );
      const shouldFire = expectation === 'fail';
      if ((matchingXsls.length > 0) === shouldFire) {
        console.log(`✓ ${fixture}`);
      } else {
        failures++;
        const detail = shouldFire
          ? `expected ${ruleId} to fire, but it did not`
          : `${ruleId} fired in ${matchingXsls.map(file => basename(file)).join(', ')}`;
        console.error(`✗ ${fixture}: ${detail}`);
      }
    } catch (error) {
      failures++;
      console.error(`✗ ${fixture}: ${error.message}`);
    }
  }
  console.log(`\n${fixtures.length - failures}/${fixtures.length} tests passed`);
  process.exitCode = failures === 0 ? 0 : 1;
}

main();
