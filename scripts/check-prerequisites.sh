#!/usr/bin/env bash
set -uo pipefail

# OpenAudit prerequisite checker
# Scans skill files for required tools and checks if they are installed.
# Exit code: 0 if all required tools present, 1 if any required tool missing.

missing_required=0

# Resolve repo root (script may be called from any directory)
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

# ── Helpers ──────────────────────────────────────────────────────────────────

check_tool() {
  local name="$1"
  local cmd="$2"
  local required="$3"  # "required" or "optional"

  local version
  if version=$( eval "$cmd" 2>&1 ); then
    # Extract first line only, trim whitespace
    version=$(echo "$version" | head -1 | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')
    printf "  %-16s [✓]     %s\n" "$name" "$version"
  else
    if [ "$required" = "required" ]; then
      printf "  %-16s [✗]     not found\n" "$name"
      missing_required=$((missing_required + 1))
    else
      printf "  %-16s [—]     not found\n" "$name"
    fi
  fi
}

# ── Header ───────────────────────────────────────────────────────────────────

echo ""
echo "  OpenAudit prerequisite check"
echo "  ════════════════════════════════════════════════════════════"
echo "  Git submodules (git clone --recursive)"
echo "  ────────────────────────────────────────────────────────────"

# ── Git submodules (deps/) ────────────────────────────────────────────────────
# Source: .gitmodules

SUBMODULES=(
  deps/archethect-sc-auditor
  deps/auditmos-skills
  deps/cyfrin-solskill
  deps/forefy-context
  deps/frankcastle-safe-solana
  deps/hackenproof-skills
  deps/kadenzipfel-scv-scan
  deps/membrane-core
  deps/pashov-skills
  deps/quillai-qs-skills
  deps/trailofbits-skills
)

for sub in "${SUBMODULES[@]}"; do
  name=$(basename "$sub")
  dir="$REPO_ROOT/$sub"
  # Check directory exists and is non-empty (has files beyond just . and ..)
  if [ -d "$dir" ] && [ "$(ls -A "$dir" 2>/dev/null)" ]; then
    printf "  %-24s [✓]     %s\n" "$name" "$sub"
  else
    printf "  %-24s [✗]     missing — run: git submodule update --init --recursive\n" "$name"
    missing_required=$((missing_required + 1))
  fi
done

echo "  ────────────────────────────────────────────────────────────"
printf "  %-16s %-8s %s\n" "Tool" "Status" "Version"
echo "  ────────────────────────────────────────────────────────────"

# ── Core system tools (required) ─────────────────────────────────────────────
# Source: skills/openaudit/SKILL.md, README.md

check_tool "python3"     "python3 --version"    required
check_tool "uv"          "uv --version"         required
check_tool "node"        "node --version"       required
check_tool "npm"         "npm --version"        required
check_tool "forge"       "forge --version"      required

# ── Python packages via uv (required) ───────────────────────────────────────
# Source: skills/openaudit/install.md, deps/archethect-sc-auditor/README.md

echo "  ────────────────────────────────────────────────────────────"
echo "  Python packages (uv sync)"
echo "  ────────────────────────────────────────────────────────────"

check_tool "slither"     "uv run slither --version"        required
check_tool "solc-select" "uv run solc-select versions"     required
check_tool "solc"        "uv run solc --version"           required
check_tool "semgrep"     "uv run semgrep --version"        required

# ── Optional tools ───────────────────────────────────────────────────────────
# Source: skills/openaudit/install.md, deps/trailofbits-skills/README.md

echo "  ────────────────────────────────────────────────────────────"
echo "  Optional tools"
echo "  ────────────────────────────────────────────────────────────"

check_tool "rustc"       "rustc --version"      optional
check_tool "cargo"       "cargo --version"      optional
check_tool "aderyn"      "aderyn --version"     optional
check_tool "codeql"      "codeql --version"     optional
check_tool "yara"        "yara --version"       optional

# ── Result ───────────────────────────────────────────────────────────────────

echo "  ════════════════════════════════════════════════════════════"

if [ "$missing_required" -eq 0 ]; then
  echo "  Result: all required tools present ✓"
  echo ""
  exit 0
else
  echo "  Result: $missing_required required tool(s) missing ✗"
  echo ""
  exit 1
fi
