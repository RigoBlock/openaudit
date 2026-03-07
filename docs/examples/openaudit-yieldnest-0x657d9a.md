# OpenAudit Summary Report: YieldNest ynETHx Vault

**Contract:** ynETH MAX (ynETHx)
**Proxy:** `0x657d9ABA1DBb59e53f9F3eCAA878447dCfC96dCb` (TransparentUpgradeableProxy)
**Implementation:** `0x9C1713BC42dCF621038F4016664fFAB096A05410` (Vault.sol)
**Chain:** Ethereum Mainnet
**Date:** 2026-03-07
**TVL:** ~4,748 ETH (~4,434 ynETHx supply)
**Audited by:** OpenAudit multi-pipeline framework

---

## Issues Found

Deduplicated findings from 8 audit pipelines and deployment analysis. INFO and LOW severity findings are omitted. Findings that are documented design decisions are excluded.

| # | Severity | Short Name | Description | Source File(s) | Relevant Addresses | Pipelines | Author Reply |
|---|----------|------------|-------------|----------------|-------------------|-----------|--------------|
| D-1 | Deployment | Overlapping Safe owners across all 3 multisigs | Three EOAs (`0xDD62...`, `0x92cf...`, `0x6A7F...`) are owners of all three Safes (Admin 3/5, Processor 2/5, Pauser 2/3). Compromise of these 3 keys grants control of all multisig operations simultaneously. | -- | Admin Safe `0xfcad...6975`, Processor Safe `0x5686...3D7D`, Pauser Safe `0xa08F...1C3` | Deployment | -- |
| D-2 | Deployment | Processor Safe low threshold (2/5) | The PROCESSOR_ROLE Safe requires only 2 of 5 signers to execute arbitrary calls through `processor()`. Combined with the Guard bypass issues below, this amplifies risk. | -- | `0x56866A6D5655C9E534320DA95fbBB82Fb3bF3D7D` | Deployment | -- |
| D-3 | Deployment | HOOKS_MANAGER not behind timelock | The hooks contract can be changed immediately by the 3/5 Admin Safe without timelock delay. Since hooks can mint unbacked shares via `mintShares()`, this is a critical configuration vector. | -- | Admin Safe `0xfcad...6975` | Deployment | -- |
| D-4 | Deployment | BUFFER_MANAGER, ASSET_WITHDRAWER, FEE_MANAGER not behind timelock | These sensitive roles are held by the Admin Safe directly, allowing immediate changes without the 24-hour timelock delay that protects PROVIDER_MANAGER and ASSET_MANAGER. | -- | Admin Safe `0xfcad...6975` | Deployment | -- |
| 1 | Critical | Hooks can mint unlimited unbacked shares | `mintShares()` in BaseVault.sol allows the hooks contract to mint arbitrary shares to any recipient with no corresponding `_addTotalAssets()` call, enabling total dilution of all vault shareholders. The hooks contract is set by HOOKS_MANAGER_ROLE (Admin Safe, no timelock). | `BaseVault.sol:998-1004` | MetaHooks `0xc33C...6bA8` | ToB, Forefy, QuillAI, Cyfrin, Auditmos | NFR Audits Sep 2025 (hooks audit) covers hooks system |
| 2 | Critical | Guard parameter validation bypass | Guard.validateCall() reads parameters at fixed 32-byte offsets assuming static ABI encoding. For functions with dynamic types (arrays, bytes, strings), the guard validates pointer values instead of actual parameters. Additionally, UINT256 parameters are silently skipped with no validation. | `Guard.sol:9-29` | -- | ToB, Pashov, SCV, Forefy, Cyfrin | Zokyo Dec 2024 audit covers Guard module |
| 3 | Critical | Processor executes arbitrary calls without reentrancy guard | `processor()` in BaseVault.sol delegates to `VaultLib.processor()` which uses raw `.call{value}()` in a loop without `nonReentrant`. Calls are made from the vault's own address, so any contract checking `msg.sender == vault` will pass. | `BaseVault.sol:984-991`, `VaultLib.sol:330-347` | Processor Safe `0x5686...3D7D` | ToB, Archethect, Cyfrin | -- |
| 4 | High | processAccounting() is permissionless | Anyone can call `processAccounting()` to force-update the cached `totalAssets`. Combined with rate provider manipulation or token donations, this enables sandwich attacks on the share price. | `BaseVault.sol:929-931` | -- | ToB, SCV, Forefy, Cyfrin, Auditmos | -- |
| 5 | High | mint() uses Floor rounding (EIP-4626 violation) | `BaseVault.mint()` calls `_convertToAssets()` with `Math.Rounding.Floor` instead of `Ceil`. This charges the minter fewer assets than the shares are worth, allowing repeated fractional value extraction. `previewMint()` correctly uses `Ceil`, creating an inconsistency. | `BaseVault.sol:310` | -- | Pashov, Cyfrin | -- |
| 6 | High | withdrawAsset bypasses fees and lacks nonReentrant | `withdrawAsset()` computes shares without adding withdrawal fees, and lacks the `nonReentrant` modifier (unlike all other mutating entry points). The ASSET_WITHDRAWER_ROLE can extract assets without fees. | `BaseVault.sol:618-633` | -- | ToB, Pashov, QuillAI, Cyfrin | -- |
| 7 | High | No rate validation on provider oracle | `IProvider.getRate()` return value is used without bounds checking, staleness check, or deviation check. A compromised or malfunctioning provider can return 0 (division by zero) or extreme values (inflating totalAssets). | `VaultLib.sol:190` | Provider `0x625e...3AD3` | ToB, QuillAI, Forefy, Auditmos | Composable Security Jan 2025 identified rate provider issues |
| 8 | High | Deposit CEI violation | `_deposit()` calls `_addTotalAssets(baseAssets)` before `safeTransferFrom()`, violating Checks-Effects-Interactions pattern. For tokens with transfer callbacks (ERC-777), accounting is updated before transfer completes. | `BaseVault.sol:543-565` | -- | ToB | Composable Security Jan 2025 (M01: reentrancy vector) |
| 9 | Medium | ERC4626 preview functions are caller-dependent | `previewWithdraw()` and `previewRedeem()` use `_msgSender()` for fee calculation instead of a fixed/owner address. Per EIP-4626, preview functions must return results independent of the caller. Integrating contracts (routers, aggregators) get incorrect values. | `BaseVault.sol:209-222` | -- | Pashov, SCV, Cyfrin | -- |
| 10 | Medium | Fee override missing bounds validation | `_overrideBaseWithdrawalFee()` does not validate the fee against `BASIS_POINT_SCALE` (1e8). A FEE_MANAGER can set per-user fee >100%, causing `previewRedeem` to underflow, permanently DoS-ing that user's redemptions. `_setBaseWithdrawalFee()` correctly validates. | `Vault.sol:134-139` | -- | ToB, Pashov, SCV, QuillAI, Forefy | -- |
| 11 | Medium | Force-fed ETH inflates share price | When `countNativeAsset` is true (current config), `computeTotalAssets()` includes `address(this).balance`. ETH can be force-sent via `selfdestruct`/CREATE2, inflating totalAssets without corresponding shares. Combined with `alwaysComputeTotalAssets=true`, this immediately affects share price. | `VaultLib.sol:306-321` | -- | Pashov, SCV, QuillAI, Auditmos | ChainSecurity and Zokyo identified donation attacks in earlier vaults |
| 12 | Medium | Stale totalAssets in cached mode | When `alwaysComputeTotalAssets=false` (current config), the cached `totalAssets` does not reflect rate changes, rebasing yield, or external balance changes. Creates arbitrage: deposit at stale rate, call `processAccounting()`, redeem at updated rate. | `BaseVault.sol:145-150` | -- | ToB, Forefy, Auditmos, QuillAI | -- |
| 13 | Medium | Fee-on-transfer token accounting mismatch | `_deposit()` credits `totalAssets` with the requested amount before transfer. If a fee-on-transfer token is added as a supported asset, the vault receives fewer tokens but credits the full amount and mints shares based on it. | `BaseVault.sol:543-565` | -- | Pashov, Auditmos, QuillAI | ChainSecurity identified rebasing token issues in earlier audits |
| 14 | Medium | No slippage protection on deposits | `deposit()`, `depositAsset()`, and `mint()` accept no minimum shares / maximum assets parameter. Share price can change between transaction submission and execution via rate changes or frontrunning. | `BaseVault.sol:292-328` | -- | SCV, Auditmos | -- |
| 15 | Medium | Minimal +1 virtual share offset | Share conversion uses `+1` offset instead of OpenZeppelin's recommended `_decimalsOffset()` (3-6). The `+1` provides minimal protection against first-depositor/inflation attacks on a high-value vault (~4,748 ETH). | `VaultLib.sol:236-264` | -- | ToB, QuillAI | ChainSecurity and Zokyo found donation/inflation attacks in earlier vaults (resolved differently) |
| 16 | Medium | Hooks returndata/gas DoS vector | Hook calls via `HooksLib.callHook()` use raw `.call()` with no gas limit. A malicious or buggy hooks contract can return unbounded data (memory bomb) or consume all gas, DoS-ing the vault's deposit/withdraw/accounting operations. | `HooksLib.sol:52-56` | MetaHooks `0xc33C...6bA8` | Cyfrin, QuillAI | NFR Audits Sep 2025 (hooks audit) |
| 17 | Medium | Buffer strategy withdraw return value unchecked | `_withdraw()` calls `IStrategy(buffer).withdraw()` but ignores the return value. If the buffer returns fewer assets than requested (due to rounding, fees, or partial fills), the discrepancy goes undetected. | `BaseVault.sol:604` | Buffer `0x45c3...0489` | Archethect, QuillAI | -- |
| 18 | Medium | Processor/processAccounting don't check paused state | `processor()` and `processAccounting()` can be called when the vault is paused. This allows state changes during emergency pause, potentially undermining the pause mechanism. | `BaseVault.sol:929, 984` | -- | QuillAI | -- |

---

## Cross Reference

| Finding | ToB | Pashov | Archethect | SCV | Forefy | QuillAI | Cyfrin | Auditmos | ChainSec | Zokyo | Composable | NFR |
|---------|-----|--------|------------|-----|--------|---------|--------|----------|----------|-------|------------|-----|
| D-1: Overlapping Safe owners | | | | | | | | | | | | |
| D-2: Processor Safe 2/5 threshold | | | | | | | | | | | | |
| D-3: HOOKS_MANAGER no timelock | | | | | | | | | | | | |
| D-4: Sensitive roles no timelock | | | | | | | | | | | | |
| 1: Unbacked share minting | C | | | | H | H | C | C | | | | H* |
| 2: Guard validation bypass | C | M | | M | H | | C | | | M* | | |
| 3: Processor no reentrancy | C | | H | | | | C | | | | | |
| 4: Permissionless processAccounting | H | M* | | M* | H | M | H | H | | | | |
| 5: mint() Floor rounding | | H | | | | | H | | | | | |
| 6: withdrawAsset bypass | H | M | | | | H | H | | | | | |
| 7: No rate validation | M* | | | | H | H | | H | | | M* | |
| 8: Deposit CEI violation | H | | | | | | | | | | M* | |
| 9: Caller-dependent previews | | H | | M | | | M | | | | | |
| 10: Fee override no max | M* | M | | M | M | M | | | | | | |
| 11: Force-fed ETH | | M | | M | | M | | M | H* | | | |
| 12: Stale totalAssets | M | | | | M | M | | M | | | | |
| 13: Fee-on-transfer mismatch | | M | | | | M | | M | M* | | | |
| 14: No slippage protection | | | | M | | | | M | | | | |
| 15: Minimal +1 offset | M | | | | | M | | | H* | H* | | |
| 16: Hooks DoS/returndata | | | | | | M | C | | | | | M* |
| 17: Buffer return unchecked | | | M | | | M | | | | | | |
| 18: Paused state bypass | | | | | | M | | | | | | |

Legend: `C` = Critical, `H` = High, `M` = Medium, `*` = found in prior/existing audit (different vault version or related component)

---

## Existing Audit Reports

| Name | Date | Auditor | Link |
|------|------|---------|------|
| Full Protocol Audit | Apr 2024 | ChainSecurity | [PDF](https://raw.githubusercontent.com/yieldnest/Publications/main/audits/chainsecurity_yieldnest_protocol_audit.pdf) |
| EigenLayer Updates | May 2024 | Zokyo | [PDF](https://raw.githubusercontent.com/yieldnest/Publications/main/audits/zokyo_audit_yieldnest_May7th_2024.pdf) |
| ynETH/ynLSDe Review | Aug 2024 | ChainSecurity | [PDF](https://raw.githubusercontent.com/yieldnest/Publications/main/audits/chainsecurity_yieldnest_protocol_audit_aug_2024.pdf) |
| MAX LRT Review | Dec 2024 | Zokyo | [PDF](https://raw.githubusercontent.com/yieldnest/Publications/main/audits/zokyo_audit_yieldnest_dec12th_2024.pdf) |
| MAX LRT, ynBTCk & ynBNBx | Jan 2025 | Composable Security | [PDF](https://raw.githubusercontent.com/yieldnest/Publications/main/audits/composable_security_yieldnest_jan_2025.pdf) |
| ynBTCk Strategy | Jan 2025 | Zokyo | [PDF](https://raw.githubusercontent.com/yieldnest/Publications/main/audits/zokyo_audit_yieldnest_Jan8th_2025.pdf) |
| EigenLayer Slashing Upgrade | Feb 2025 | Zokyo | [PDF](https://raw.githubusercontent.com/yieldnest/Publications/main/audits/zokyo_audit_yieldnest_feb4th_2025.pdf) |
| Max Vault Withdrawer | Feb 2025 | NFR Audits | [PDF](https://raw.githubusercontent.com/yieldnest/Publications/main/audits/yieldnest_max_vault_withdrawer_audit_report.pdf) |
| ynETH Slashing Upgrade | Apr 2025 | Zokyo | [PDF](https://raw.githubusercontent.com/yieldnest/Publications/main/audits/zokyo_yneth_audit_yieldnest_april_2025.pdf) |
| ynEigen Slashing Upgrade | Apr 2025 | Zokyo | [PDF](https://raw.githubusercontent.com/yieldnest/Publications/main/audits/zokyo_yneigen_audit_yieldnest_april_2025.pdf) |
| Default Asset Index | May 2025 | NFR Audits | [PDF](https://raw.githubusercontent.com/yieldnest/Publications/main/audits/yieldnest_default_asset_index_audit_report.pdf) |
| clisBNB Strategy | May 2025 | NFR Audits | [PDF](https://raw.githubusercontent.com/yieldnest/Publications/main/audits/yieldnest_clisbnb_strategy_audit_report.pdf) |
| Flex Strategy | Jul 2025 | NFR Audits | Downloaded from YieldNest Docs |
| MetaHook | Sep 2025 | NFR Audits | Downloaded from YieldNest Docs |
| Performance Fees | Sep 2025 | NFR Audits | Downloaded from YieldNest Docs |
| Hooks | Sep 2025 | NFR Audits | Downloaded from YieldNest Docs |

Active bug bounty: [Immunefi](https://immunefi.com/bug-bounty/yieldnest/) (up to $200,000 for critical)

---

## Skipped Pipelines

| Pipeline Name | Reason |
|---------------|--------|
| hackenproof-skills | Bug bounty triage tool, not an audit pipeline. Designed for evaluating bug bounty submissions, not generating findings from source code. |

---

## Individual Pipeline Reports

| Pipeline | Report | Findings (M+) |
|----------|--------|---------------|
| Trail of Bits Skills | [trailofbits-skills.md](trailofbits-skills.md) | 3C, 4H, 5M |
| Pashov Skills | [pashov-skills.md](pashov-skills.md) | 7 findings (95-75 confidence) |
| Archethect (Slither+Aderyn) | [archethect-sc-auditor.md](archethect-sc-auditor.md) | 2H, 6M |
| SCV Scan | [kadenzipfel-scv-scan.md](kadenzipfel-scv-scan.md) | 6M |
| Forefy Context | [forefy-context.md](forefy-context.md) | 3H, 4M |
| QuillAI QS Skills | [quillai-qs-skills.md](quillai-qs-skills.md) | 2H, 8M |
| Cyfrin Solskill | [cyfrin-solskill.md](cyfrin-solskill.md) | 5C, 5H, 11M |
| Auditmos Skills | [auditmos-skills.md](auditmos-skills.md) | 1C, 4H, 6M |
| Deployment Analysis | [addresses-yieldnest-0x657d9a.md](addresses-yieldnest-0x657d9a.md) | 4 deployment concerns |
| Existing Audits | [existing-audits-summary.md](existing-audits-summary.md) | 16 prior audits found |

---

*Generated by [OpenAudit](https://github.com/tradingstrategy-ai/openaudit) multi-pipeline smart contract auditing framework.*
