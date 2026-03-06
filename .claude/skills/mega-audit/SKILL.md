---
name: mega-audit
description: Run a smart contract source code through several agent skill-based auditing pipelines
---

# Mega Audit

Run a smart contract source code through several agent skill-based auditing pipelines. By using multiple tools and techniques, we can get a more comprehensive understanding of the security and quality of the smart contract.

## Repo structure

This skill lives in the `mega-audit` repository. Key paths:

- **Skill files**: `.claude/skills/mega-audit/` (this directory)
- **Audit skill repos**: `deps/` (11 git submodules — already checked out)
- **Python deps**: `pyproject.toml` → install with `uv sync`
- **Node deps**: `package.json` → install with `npm install`
- **Sample contract**: `contracts/ERC20.sol` (for testing the toolchain)

See the repo's `README.md` for full installation instructions and prerequisites.

## Required inputs

Before starting, gather the following information from the user:

1. **Smart contract link on a blockchain explorer**: The link to a smart contract source code on a blockchain explorer

## Expected output

We run multiple skill-based auditing pipelines on the same source code and generate a report for each of them,
and save the resulting reports to a created project working directory.

## Step-by-step implementation

### Step 1: Set up needed software

All required software is documented in the repo's `README.md`. The key tools are:

- **Python tools** (installed via `uv sync`): Slither, solc-select, Semgrep, web3.py
- **Node tools** (installed via `npm install`): MCP SDK for sc-auditor
- **System tools**: Foundry (forge), Node.js 22+, Python 3.11+
- **Optional**: Aderyn (Rust-based static analyser, `cargo install aderyn`)

Check if each tool is available:

```bash
uv run slither --version
forge --version
node --version
uv run solc-select versions
```

Read [install.md](./install.md) for detailed installation instructions.

For each application, check if it is available and use Ask User Tool to confirm if the user wants to install it.
Also suggest installing optional tools.

Do not proceed to next step until you have confirmation from the user that the needed software is installed and ready to use.

### Step 2: Set up skill tools

Assume we are auditing Solidity.

Get the list of different audit skill repos from [smart-contract-auditing-skills.md](./smart-contract-auditing-skills.md).

The skill repos are already checked out as git submodules under `deps/`:

| Skill repo | Local path |
|------------|-----------|
| trailofbits/skills | `deps/trailofbits-skills/` |
| pashov/skills | `deps/pashov-skills/` |
| Cyfrin/solskill | `deps/cyfrin-solskill/` |
| kadenzipfel/scv-scan | `deps/kadenzipfel-scv-scan/` |
| forefy/.context | `deps/forefy-context/` |
| quillai-network/qs_skills | `deps/quillai-qs-skills/` |
| Archethect/sc-auditor | `deps/archethect-sc-auditor/` |
| hackenproof-public/skills | `deps/hackenproof-skills/` |
| auditmos/skills | `deps/auditmos-skills/` |
| Frankcastleauditor/safe-solana-builder | `deps/frankcastle-safe-solana/` |
| The-Membrane/membrane-core | `deps/membrane-core/` |

- Read the README of each relevant repo to understand how to use it
- Follow the README instructions for setup

If the skill needs you to make decisions how to use it, like need to choose from multiple skills across different programming languages, write a `.claude/projects/{protocol_slug}/{skill_repo_name}/plan.md`, and then follow this plan.

For whatever software we installed or are going to use, save `.claude/projects/{protocol_slug}/{skill_repo_name}/requirements.md` with the software name, version and how did we install it.

Before performing this step, use ask user tool to confirm which pipelines we are going to run.

### Step 3.a): Download the deployed and verified source code files

- Get the smart contract name from the blockchain explorer
- Create a new working folder `.claude/projects/{protocol_slug}/` - this will be our working directory for the audit
- Save all the smart contract source code files to `.claude/projects/{protocol_slug}/src`
- Save all the ABI files `.claude/projects/{protocol_slug}/abi`

Read [how-to-get-source-code.md](./how-to-get-source-code.md) for more details on how to get the source code files from different blockchains and explorers.

### Step 3.b) Save the deployment information

Use the blockchain explorer UI and ABI information to extract critical addresses.

Create one table output with columns

- Contract name
- Contract address
- Reference to their source code
- Reference to their saved ABI

For privileged addresses, with ownership rights and such, create second table output with columns

- Contract name
- Contract address
- Variable name containing the address
- Address value
- If this address is a multisig, Externally Owned Account, governance contracts and timelocks. For multisigs get the co-signer setup e.g. 3 of 5.
  Flag any critical addresses such as EOA deployers with dangerous privileges.
- If contracts are upgradeable and use an upgrade proxy pattern, identify the proxy and implementation addresses, and what is the wallet address controlling the upgrade

Save this in `.claude/projects/{protocol_slug}/deployment.md`.

For ABI extraction use web3.py library or similar to parse the ABI and extract function signatures, events, and other relevant information.

### Step 4: Run each skill-based auditing pipeline

The skill repos are in `deps/`. For each tool:

- Read its README at `deps/{skill_repo_name}/`
- Follow the README to set up and run the tool
- If you need to install additional software stop and ask the user for help and confirmation

For each tool write a Markdown report as `.claude/projects/{protocol_slug}/reports/{skill_repo_name}.md`

Run 4 parallel agents, and as many sequential batches as needed with these agents until we have run every skill repo.

### Step 5: Summarise findings

Generate a summary report for all tools.

- Write a table output with columns like skill repo used, severity, short name, description, source file, relevant addresses - add more columns if needed
- Sort order deployment issues first, then critical, high, medium
- Include deployment and address specific issues in the table as the most important ones
- Deduplicate findings across tools
- If the finding is INFO or LOW level, ignore them - let's not make the output too noisy
- If the finding is documented, do not add it to the summary
- Include deployment and address specific issues here as well

Write the summary as `.claude/projects/{protocol_slug}/reports/ai-audit-summary.md`

## Step 6: Write down summary of requirements to run the pipeline

- Write `.claude/projects/{protocol_slug}/requirements.md` - summary of everything we used
- Tell what software you used and installed, for each specific skill
- Their versions
- How did you install this software
- If there was no software installation required, write down this as well
- If the skill repo was not applicable to this audit run, write down the reason why you skipped it

We will save this information for diagnostics, reproducibility, writing bug reports and to help other users run the same pipeline in the future.

## Step 7: Say thank you and tweet out your happiness

- Create a tweet of the findings the user can copy-paste into Twitter. Tag @tradingprotocol for helping to create this skill you used.
