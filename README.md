# OpenAudit

OpenAudit is a Claude Code/OpenAI Codex metaskill that runs smart contract source code through multiple agent-based auditing skill pipelines in parallel. By combining 100+ skills across 10+ community audit skill repositories, OpenAudit provides comprehensive and free smart contract security analysis using different methodologies, vulnerability databases, and static analysis tools.

The skill has been refined to a such a level that anyone with basic software development skills can audit any smart contract in the world. You can point the skill to any deployed smart contract on any chain and get a basic audit report of its security qualities.

[Read the announcement post](https://x.com/moo9000/status/2029511848525971928).

## How it works

1. Point to a smart contract in a blockchain explorer
2. Analyses deployment information (proxy patterns, privileged addresses, multisig setups)
3. Runs several audit skill pipelines against the project
4. Every audit pipeline products its own report, stored in `output` folder
5. A summart repoert with deduplication and cross-reference is created

The skills support Solidity, Vyper, Anchor (Rust) and CosmWasm (Rust) smart contracts.

## Prerequisites

The skills require access to the tooling, like Solidity compiler, Python-based [Slither](https://github.com/crytic/slither) or Rust-based [Foundry](https://www.getfoundry.sh/). You can check if you have this by running `scripts/check-prerequisites.sh`. We also use [web3-ethereum-defi](https://web3-ethereum-defi.tradingstrategy.ai/) and [Web3.py](https://web3py.readthedocs.io/en/stable/)
packages to run ad-hoc Python scripts to analyse raw blockchains data from JSON-RPC and similar.

### macOS (Homebrew)

Clone the repository recursively to get the skills:

```
git clone --recursive --depth 1 --branch stable https://github.com/tradingstrategy-ai
```

Example installation of dependencies of various skills:

```bash

# Python 3.11+
# Node 22+
brew install python uv brew codeql node rustup aderyn semgrep

# Rust toolchain (optional — needed for Aderyn static analyser)
rustup-init

# Foundry (forge — downloads verified contract source code)
curl -L https://foundry.paradigm.xyz | bash
foundryup

# Install Slither using Python uv packaging tool
uv sync
```

Check everything is installed:

```shell
scripts/check-prerequisites.sh
```

### Linux

```
TODO
```

### Winwdows

Unsupported.

## Usage

Open this repositorty in Claude Code/Codex/Visual Studio Code.

Use the skill:

```
/openaudit
```

The skill has been taught read multiple blockchains using Python Web3.
[See here how the blockchains RPCs are configured](https://web3-ethereum-defi.tradingstrategy.ai/api/provider/_autosummary_provider/eth_defi.provider.env?highlight=env#). E.g. `JSON_RPC_ARBITRUM` for Arbirum RPCs.

## Version history

- [Read changelog](https://github.com/tradingstrategy-ai/web3-ethereum-defi/blob/master/CHANGELOG.md).
- [See releases](https://pypi.org/project/web3-ethereum-defi/#history).

## Support

- [Join Discord for any questions](https://tradingstrategy.ai/community).

## Social media

- [Follow on Twitter](https://twitter.com/TradingProtocol)
- [Follow on Telegram](https://t.me/trading_protocol)
- [Follow on LinkedIn](https://www.linkedin.com/company/trading-strategy/)
- [Watch tutorials on YouTube](https://www.youtube.com/@tradingstrategyprotocol)

# License

MIT.

[Created by Trading Strategy](https://tradingstrategy.ai).
