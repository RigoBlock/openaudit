# Mega Audit

A [Claude Code](https://docs.anthropic.com/en/docs/claude-code) skill that runs smart contract source code through multiple agent-based auditing pipelines in parallel. By combining ~93 skills across 11 community audit skill repositories, mega-audit provides comprehensive security analysis using different methodologies, vulnerability databases, and static analysis tools.

[Read the announcement post](https://x.com/moo9000/status/2029511848525971928).

## How it works

1. Downloads verified smart contract source code from a blockchain explorer
2. Analyses deployment information (proxy patterns, privileged addresses, multisig setups)
3. Runs 4 parallel Claude Code agents, each executing different audit skill repos
4. Deduplicates and summarises findings into a severity-ranked report

## Prerequisites

### macOS (Homebrew)

```bash
# Python 3.11+
brew install python@3.11

# uv (Python package manager)
brew install uv

# Node.js 22+ (for sc-auditor MCP server)
brew install node@22

# Foundry (forge — downloads verified contract source code)
curl -L https://foundry.paradigm.xyz | bash
foundryup

# Rust toolchain (optional — needed for Aderyn static analyser)
brew install rustup
rustup-init
```

### Linux

TODO

## Installation

```bash
# Clone with all skill submodules
git clone --recursive https://github.com/user/mega-audit.git
cd mega-audit

# Install Python dependencies (slither, solc-select, semgrep, web3)
uv sync

# Install Node dependencies (MCP SDK, zod)
npm install

# Build the sc-auditor MCP server
cd deps/archethect-sc-auditor && npm install && npm run build && cd ../..

# Install the Solidity compiler
uv run solc-select install 0.8.28
uv run solc-select use 0.8.28

# Optional: install Aderyn (Rust-based static analyser)
cargo install aderyn
```

## Usage

The mega-audit skill is located at `.claude/skills/mega-audit/SKILL.md`. When this repo is your working directory, Claude Code can invoke it via `/mega-audit`.

You need to provide a link to a verified smart contract on a blockchain explorer (Etherscan, Basescan, Arbiscan, etc.).

## Repo structure

```
.claude/skills/mega-audit/   — The skill files (orchestration, install guide, skill catalogue)
contracts/                    — Sample ERC-20 contract for CI testing
deps/                         — Git submodules of all 11 audit skill repos
pyproject.toml                — Python dependencies (uv sync)
package.json                  — Node dependencies (npm install)
```

## Included skill repos

| Repo | Stars | Skills | Description |
|------|------:|-------:|-------------|
| [trailofbits/skills](https://github.com/trailofbits/skills) | 3,274 | 58 | Comprehensive security research skills (Solidity, Cairo, Cosmos, Go, Rust, Python, C/C++) |
| [pashov/skills](https://github.com/pashov/skills) | 156 | 1 | Parallelised 4-agent Solidity audit pipeline |
| [Cyfrin/solskill](https://github.com/Cyfrin/solskill) | 96 | 1 | Production-grade Solidity development standards |
| [kadenzipfel/scv-scan](https://github.com/kadenzipfel/scv-scan) | 77 | 1 | Pure-Markdown vulnerability scanner (36 vulnerability types) |
| [forefy/.context](https://github.com/forefy/.context) | 70 | 3 | Multi-expert framework for Solidity, Anchor, and Vyper |
| [quillai-network/qs_skills](https://github.com/quillai-network/qs_skills) | 62 | 10 | QuillShield methodology covering OWASP Smart Contract Top 10 |
| [Archethect/sc-auditor](https://github.com/Archethect/sc-auditor) | 47 | 1+4 | MCP server with Slither, Aderyn, and Solodit integration |
| [Frankcastleauditor/safe-solana-builder](https://github.com/Frankcastleauditor/safe-solana-builder) | 47 | 1 | Security-first Solana program writing (Anchor + Native Rust) |
| [The-Membrane/membrane-core](https://github.com/The-Membrane/membrane-core) | 10 | 1 | CosmWasm audit patterns from 61 Oak Security reports |
| [hackenproof-public/skills](https://github.com/hackenproof-public/skills) | 7 | 1 | Bug bounty triage workflow |
| [auditmos/skills](https://github.com/auditmos/skills) | 0 | 14 | 14 DeFi vulnerability-specific skills |

**Total: ~93 skills across ~121,000 lines of audit knowledge.**

## Installed software

### Python (via `uv sync`)

| Package | Purpose |
|---------|---------|
| slither-analyzer | Solidity static analysis |
| solc-select | Solidity compiler version manager |
| semgrep | Pattern-based static analysis (Trail of Bits plugins) |
| web3 | On-chain queries during deployment analysis |

### Node (via `npm install`)

| Package | Purpose |
|---------|---------|
| @modelcontextprotocol/sdk | MCP server framework (for sc-auditor) |
| zod | Schema validation (for sc-auditor) |

### System tools (manual install)

| Tool | Purpose | Install |
|------|---------|---------|
| Foundry (forge) | Download verified contract source code | `foundryup` |
| Node.js 22+ | Runtime for sc-auditor MCP server | `brew install node@22` |
| Python 3.11+ | Runtime for Slither and other tools | `brew install python@3.11` |
| Rust toolchain | Optional — needed for Aderyn | `rustup-init` |
| Aderyn | Optional — Rust-based Solidity static analyser | `cargo install aderyn` |
