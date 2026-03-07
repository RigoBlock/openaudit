---
name: openaudit
description: Run a smart contract source code through several agent skill-based auditing pipelines
---

# OpenAudit

Run a smart contract source code through several agent skill-based auditing pipelines. By using multiple tools and techniques, we can get a more comprehensive understanding of the security and quality of the smart contract.

## Repo structure

This skill lives in the `openaudit` repository. Key paths:

- **Skill files**: `skills/openaudit/` (this directory)
- **Audit skill repos**: `deps/` (11 git submodules — already checked out)
- **Python deps**: `pyproject.toml` → install with `uv sync`
- **Node deps**: `package.json` → install with `npm install`
- **Sample contract**: `contracts/ERC20.sol` (for testing the toolchain)

See the repo's `README.md` for full installation instructions and prerequisites.

## Required inputs

Before starting, gather the following information from the user:

1. **Smart contract link on a blockchain explorer** or **smart contract source code repository path**: The link to a smart contract source code on a blockchain explorer
2. **Project name** we will use for a working directory and report naming, like _Aave_.

## Expected output

We run multiple skill-based auditing pipelines on the same source code and generate a report for each of them,
and save the resulting reports to a created project working directory.

## Step-by-step implementation

### Step 1: Set up needed software

Run `scripts/check-prerequisites.sh` to check what software we have installed the skills may ask.

### Step 2: Create a project working directory.

Create a project `out/{protocol_slug}`.

- Slugify the project name using kebab casing.
- If we gave a deployed smart contract address, include 6 first letters in its name e.g. `aave-0x123456`.

### Step 3: Set up skill

Assume we are auditing Solidity unless otherwise stated.

Get the list of different audit skill repos from [smart-contract-auditing-skills.md](./smart-contract-auditing-skills.md).

- Read the README of each relevant repo to understand how to use it
- Follow the README instructions for setup

If the skill needs you to make decisions how to use it, like need to choose from multiple skills across different programming languages, write a `.claude/projects/{protocol_slug}/{skill_repo_name}/plan.md`, and then follow this plan.

For whatever software we installed or are going to use, save `.claude/projects/{protocol_slug}/{skill_repo_name}/requirements.md` with the software name, version and how did we install it.

Before performing this step, use ask user tool to confirm which pipelines we are going to run.

### Step 4.a): Download the deployed and verified source code files

- Get the smart contract name from the blockchain explorer
- Create a new working folder `.claude/projects/{protocol_slug}/` - this will be our working directory for the audit
- Save all the smart contract source code files to `.claude/projects/{protocol_slug}/src`
- Save all the ABI files `.claude/projects/{protocol_slug}/abi`

Read [how-to-get-source-code.md](./how-to-get-source-code.md) for more details on how to get the source code files from different blockchains and explorers.

### Step 4.b) Save the deployment information

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

Save this in `out/{protocol_slug}/deployment.md`.

For ABI extraction use web3.py library or similar to parse the ABI and extract function signatures, events, and other relevant information.

Use [Web3.py](https://web3py.readthedocs.io/) for reading onchain data.
[We are using web3-eth-defu environment variables for JSON-RPC configuration, supporting multiple RPCs per chain](https://web3-ethereum-defi.tradingstrategy.ai/api/provider/_autosummary_provider/eth_defi.provider.env).

### Step 5: Run each skill-based auditing pipeline

The skill repos are in `deps/`. For each tool:

- Read its README at `deps/{skill_repo_name}/`
- Follow the README to set up and run the tool
- If you need to install additional software stop and ask the user for help and confirmation

For each tool write a Markdown report as `out/{protocol_slug}/reports/{skill_repo_name}.md`

Run 4 parallel agents, and as many sequential batches as needed with these agents until we have run every skill repo.

### Step 6: Summarise findings

Generate a summary report for all tools.

- Write a table output with columns like skill repo used, severity, short name, description, source file, relevant addresses - add more columns if needed
- Sort order deployment issues first, then critical, high, medium
- Include deployment and address specific issues in the table as the most important ones
- Deduplicate findings across tools
- If the finding is INFO or LOW level, ignore them - let's not make the output too noisy
- If the finding is documented, do not add it to the summary
- Include deployment and address specific issues here as well

Write the summary as `out/{protocol_slug}/reports/openaudit-{protocol_slug}.md`

## Step 7: Say thank you and tweet out your happiness

- Create a tweet of the findings the user can copy-paste into Twitter. Tag @tradingprotocol for helping to create this skill you used.
- Open X compose page in a browser and paste this tweet, and ask user to press submit
