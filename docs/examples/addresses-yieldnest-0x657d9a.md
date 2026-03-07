# YieldNest ynETHx Vault - Address & Deployment Report

**Vault name:** ynETH MAX (ynETHx)
**Chain:** Ethereum Mainnet (chainId: 1)
**Proxy:** `0x657d9ABA1DBb59e53f9F3eCAA878447dCfC96dCb`
**Report date:** 2026-03-07

---

## Table 1 - Contracts

| Contract Name                       | Address                                      | Source / Etherscan                                                                                                                             | ABI                                                                         |
| ----------------------------------- | -------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------- | --------------------------------------------------------------------------- |
| TransparentUpgradeableProxy (Vault) | `0x657d9ABA1DBb59e53f9F3eCAA878447dCfC96dCb` | [Etherscan](https://etherscan.io/address/0x657d9ABA1DBb59e53f9F3eCAA878447dCfC96dCb#code)                                                      | [TransparentUpgradeableProxy.json](../abi/TransparentUpgradeableProxy.json) |
| Vault (implementation)              | `0x9C1713BC42dCF621038F4016664fFAB096A05410` | [Etherscan](https://etherscan.io/address/0x9C1713BC42dCF621038F4016664fFAB096A05410#code)                                                      | [Vault.json](../abi/Vault.json)                                             |
| ProxyAdmin                          | `0xA02A8DC24171aC161cCb74Ef02C28e3cA2204783` | [Etherscan](https://etherscan.io/address/0xA02A8DC24171aC161cCb74Ef02C28e3cA2204783#code)                                                      | OpenZeppelin ProxyAdmin                                                     |
| TimelockController                  | `0xb5b52c63067E490982874B0d0F559668Bbe0c36B` | [Etherscan](https://etherscan.io/address/0xb5b52c63067E490982874B0d0F559668Bbe0c36B#code)                                                      | OpenZeppelin TimelockController                                             |
| Provider                            | `0x625eEedcAA859fe79DAAD8348671eb3cFCCA3AD3` | [Etherscan](https://etherscan.io/address/0x625eEedcAA859fe79DAAD8348671eb3cFCCA3AD3#code)                                                      | --                                                                          |
| Buffer (BeaconProxy -> EVault)      | `0x45c3B59d53e2e148Aaa6a857521059676D5c0489` | [Etherscan](https://etherscan.io/address/0x45c3B59d53e2e148Aaa6a857521059676D5c0489#code) (impl: `0x8ff1c814719096b61abf00bb46ead0c9a529dd7d`) | Euler EVault                                                                |
| MetaHooks                           | `0xc33C5B232053C516a8271f5Fefb4a8AEc65e6bA8` | [Etherscan](https://etherscan.io/address/0xc33C5B232053C516a8271f5Fefb4a8AEc65e6bA8#code)                                                      | --                                                                          |
| YieldNest Admin Safe (3/5)          | `0xfcad670592a3b24869C0b51a6c6FDED4F95D6975` | [Etherscan](https://etherscan.io/address/0xfcad670592a3b24869C0b51a6c6FDED4F95D6975)                                                           | GnosisSafeProxy (impl: `0xd9Db270c1B5E3Bd161E8c8503c55cEABeE709552`)        |
| Processor Safe (2/5)                | `0x56866A6D5655C9E534320DA95fbBB82Fb3bF3D7D` | [Etherscan](https://etherscan.io/address/0x56866A6D5655C9E534320DA95fbBB82Fb3bF3D7D)                                                           | SafeProxy (impl: `0x41675C099F32341bf84BFc5382aF534df5c7461a`)              |
| Pauser Safe (2/3)                   | `0xa08F39d30dc865CC11a49b6e5cBd27630D6141C3` | [Etherscan](https://etherscan.io/address/0xa08F39d30dc865CC11a49b6e5cBd27630D6141C3)                                                           | GnosisSafeProxy (impl: `0xd9Db270c1B5E3Bd161E8c8503c55cEABeE709552`)        |

---

## Vault Configuration

| Parameter                    | Value                                                                       |
| ---------------------------- | --------------------------------------------------------------------------- |
| `name()`                     | ynETH MAX                                                                   |
| `symbol()`                   | ynETHx                                                                      |
| `decimals()`                 | 18                                                                          |
| `asset()` (base asset)       | `0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2` (WETH)                         |
| `paused()`                   | false                                                                       |
| `provider()`                 | `0x625eEedcAA859fe79DAAD8348671eb3cFCCA3AD3` (Provider)                     |
| `buffer()`                   | `0x45c3B59d53e2e148Aaa6a857521059676D5c0489` (eWETH-22, EVault BeaconProxy) |
| `hooks()`                    | `0xc33C5B232053C516a8271f5Fefb4a8AEc65e6bA8` (MetaHooks)                    |
| `baseWithdrawalFee()`        | 250000 (0.25%)                                                              |
| `countNativeAsset()`         | true                                                                        |
| `alwaysComputeTotalAssets()` | false                                                                       |
| `defaultAssetIndex()`        | 0                                                                           |
| `totalAssets()`              | ~4748.46 ETH                                                                |
| `totalSupply()`              | ~4434.53 ynETHx                                                             |

### Assets (15)

| #   | Address                                      | Name                                | Symbol                    | Decimals |
| --- | -------------------------------------------- | ----------------------------------- | ------------------------- | -------- |
| 0   | `0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2` | Wrapped Ether                       | WETH                      | 18       |
| 1   | `0x09db87A538BD693E9d08544577d5cCfAA6373A48` | ynETH                               | ynETH                     | 18       |
| 2   | `0x35Ec69A77B79c255e5d47D5A3BdbEFEfE342630c` | YieldNest Restaked LSD - Eigenlayer | ynLSDe                    | 18       |
| 3   | `0xae7ab96520DE3A18E5e111B5EaAb095312D7fE84` | Liquid staked Ether 2.0             | stETH                     | 18       |
| 4   | `0x45c3B59d53e2e148Aaa6a857521059676D5c0489` | EVK Vault eWETH-22                  | eWETH-22                  | 18       |
| 5   | `0x823976dA34aC45C23a8DfEa51B3Ff1Ae0D980213` | Curve ynETH-LSD Factory yVault      | yvCurve-ynETH-LSD-f       | 18       |
| 6   | `0x7f39C581F595B53c5cb19bD0b3f8dA6c935E2Ca0` | Wrapped liquid staked Ether 2.0     | wstETH                    | 18       |
| 7   | `0x856c4Efb76C1D1AE02e20CEB03A2A6a08b0b8dC3` | Origin Ether                        | OETH                      | 18       |
| 8   | `0xDcEe70654261AF21C44c093C300eD3Bb97b78192` | Wrapped OETH                        | wOETH                     | 18       |
| 9   | `0x3527663fa14F1799FfDF54fdC7e721D2fB8e88d5` | ynETH MAX Withdrawer                | ynETHxWithdrawer          | 18       |
| 10  | `0x833AdaeF212c5cD3f78906B44bBfb18258F238F0` | Smokehouse WSTETH                   | bbqWSTETH                 | 18       |
| 11  | `0x9a8bC3B04b7f3D87cfC09ba407dCED575f2d61D8` | MEV Capital wETH                    | MCwETH                    | 18       |
| 12  | `0x90a8FF2709DbD9Cb02e8B6FA28386fB57Bd7B67b` | YieldNest WETH Flex Strategy        | ynFlex-WETH-ynETHx-ARB1   | 18       |
| 13  | `0x0B925eD163218f6662a35e0f0371Ac234f9E9371` | Aave Ethereum wstETH                | aEthwstETH                | 18       |
| 14  | `0x115B50649e50c2b36B3D2Ec0928E72492c85dA7D` | YieldNest wstETH Flex Strategy      | ynFlex-wstETH-ynETHx-LVG1 | 18       |

---

## Table 2 - Privileged Addresses

### Proxy Upgrade Path

| Contract                    | Variable / Slot      | Address                                                                                            | Type                          | Details                                    |
| --------------------------- | -------------------- | -------------------------------------------------------------------------------------------------- | ----------------------------- | ------------------------------------------ |
| TransparentUpgradeableProxy | ERC1967 admin slot   | `0xA02A8DC24171aC161cCb74Ef02C28e3cA2204783`                                                       | Contract (ProxyAdmin)         | OpenZeppelin ProxyAdmin                    |
| ProxyAdmin                  | `owner()`            | `0xb5b52c63067E490982874B0d0F559668Bbe0c36B`                                                       | Contract (TimelockController) | 24-hour delay                              |
| TimelockController          | `DEFAULT_ADMIN_ROLE` | `0xb5b52c63067E490982874B0d0F559668Bbe0c36B` (self) + `0xfcad670592a3b24869C0b51a6c6FDED4F95D6975` | Timelock + Multisig (3/5)     | Timelock self-admin + YieldNest Admin Safe |
| TimelockController          | `PROPOSER_ROLE`      | `0xfcad670592a3b24869C0b51a6c6FDED4F95D6975`                                                       | Multisig (3/5)                | YieldNest Admin Safe                       |
| TimelockController          | `EXECUTOR_ROLE`      | `0xfcad670592a3b24869C0b51a6c6FDED4F95D6975`                                                       | Multisig (3/5)                | YieldNest Admin Safe                       |
| TimelockController          | `CANCELLER_ROLE`     | `0xfcad670592a3b24869C0b51a6c6FDED4F95D6975`                                                       | Multisig (3/5)                | YieldNest Admin Safe                       |

### Vault Access Control Roles

| Role                     | Address                                      | Type                          | Details                                                                                 |
| ------------------------ | -------------------------------------------- | ----------------------------- | --------------------------------------------------------------------------------------- |
| `DEFAULT_ADMIN_ROLE`     | `0xfcad670592a3b24869C0b51a6c6FDED4F95D6975` | Multisig (3/5 Safe)           | YieldNest Admin Safe - can grant/revoke all roles                                       |
| `PROCESSOR_ROLE`         | `0x56866A6D5655C9E534320DA95fbBB82Fb3bF3D7D` | Multisig (2/5 Safe)           | Processor Safe - can call `processor()`                                                 |
| `PROCESSOR_ROLE`         | `0xfcad670592a3b24869C0b51a6c6FDED4F95D6975` | Multisig (3/5 Safe)           | YieldNest Admin Safe                                                                    |
| `PAUSER_ROLE`            | `0xa08F39d30dc865CC11a49b6e5cBd27630D6141C3` | Multisig (2/3 Safe)           | Pauser Safe - can call `pause()`                                                        |
| `UNPAUSER_ROLE`          | `0xfcad670592a3b24869C0b51a6c6FDED4F95D6975` | Multisig (3/5 Safe)           | YieldNest Admin Safe - can call `unpause()`                                             |
| `PROVIDER_MANAGER_ROLE`  | `0xb5b52c63067E490982874B0d0F559668Bbe0c36B` | Contract (TimelockController) | 24h timelock - can call `setProvider()`                                                 |
| `BUFFER_MANAGER_ROLE`    | `0xb5b52c63067E490982874B0d0F559668Bbe0c36B` | Contract (TimelockController) | 24h timelock - can call `setBuffer()`                                                   |
| `BUFFER_MANAGER_ROLE`    | `0xfcad670592a3b24869C0b51a6c6FDED4F95D6975` | Multisig (3/5 Safe)           | YieldNest Admin Safe                                                                    |
| `ASSET_MANAGER_ROLE`     | `0xb5b52c63067E490982874B0d0F559668Bbe0c36B` | Contract (TimelockController) | 24h timelock - can call `addAsset()`, `deleteAsset()`, `updateAsset()`                  |
| `PROCESSOR_MANAGER_ROLE` | `0x657d9ABA1DBb59e53f9F3eCAA878447dCfC96dCb` | Contract (Vault itself)       | Self-reference                                                                          |
| `PROCESSOR_MANAGER_ROLE` | `0xb5b52c63067E490982874B0d0F559668Bbe0c36B` | Contract (TimelockController) | 24h timelock - can call `setProcessorRule()`                                            |
| `HOOKS_MANAGER_ROLE`     | `0xfcad670592a3b24869C0b51a6c6FDED4F95D6975` | Multisig (3/5 Safe)           | YieldNest Admin Safe - can call `setHooks()`                                            |
| `ASSET_WITHDRAWER_ROLE`  | `0xfcad670592a3b24869C0b51a6c6FDED4F95D6975` | Multisig (3/5 Safe)           | YieldNest Admin Safe                                                                    |
| `FEE_MANAGER_ROLE`       | `0xfcad670592a3b24869C0b51a6c6FDED4F95D6975` | Multisig (3/5 Safe)           | YieldNest Admin Safe - can call `setBaseWithdrawalFee()`, `overrideBaseWithdrawalFee()` |

---

## Multisig Details

### YieldNest Admin Safe (3/5)

**Address:** `0xfcad670592a3b24869C0b51a6c6FDED4F95D6975`

| #   | Owner                                        | Type |
| --- | -------------------------------------------- | ---- |
| 1   | `0xE27B5c80DE762cd47f824515f845CB4bec881F88` | EOA  |
| 2   | `0x6A7Ff17e8347e7EAd5856c83299ACb506Cb878b3` | EOA  |
| 3   | `0xDD62d882ca6bE24d08D0067A4660d9165eb9F80C` | EOA  |
| 4   | `0xF522712DdAb999493D716eD681D8a0fb5C5FdC90` | EOA  |
| 5   | `0x92cfFf81BD9D3ca540d3ee7e7d26A67b47FdB7c8` | EOA  |

### Processor Safe (2/5)

**Address:** `0x56866A6D5655C9E534320DA95fbBB82Fb3bF3D7D`

| #   | Owner                                        | Type |
| --- | -------------------------------------------- | ---- |
| 1   | `0x296D28BBBdaFAacc69881005bF1db399Cc1028e3` | EOA  |
| 2   | `0xF522712DdAb999493D716eD681D8a0fb5C5FdC90` | EOA  |
| 3   | `0x92cfFf81BD9D3ca540d3ee7e7d26A67b47FdB7c8` | EOA  |
| 4   | `0xDD62d882ca6bE24d08D0067A4660d9165eb9F80C` | EOA  |
| 5   | `0x6A7Ff17e8347e7EAd5856c83299ACb506Cb878b3` | EOA  |

### Pauser Safe (2/3)

**Address:** `0xa08F39d30dc865CC11a49b6e5cBd27630D6141C3`

| #   | Owner                                        | Type |
| --- | -------------------------------------------- | ---- |
| 1   | `0xDD62d882ca6bE24d08D0067A4660d9165eb9F80C` | EOA  |
| 2   | `0x92cfFf81BD9D3ca540d3ee7e7d26A67b47FdB7c8` | EOA  |
| 3   | `0x6A7Ff17e8347e7EAd5856c83299ACb506Cb878b3` | EOA  |

---

## Deployer

| Address                                                                           | Type |
| --------------------------------------------------------------------------------- | ---- |
| `0xa1E340bd1e3ea09B3981164BBB4AfeDdF0e7bA0D`                                      | EOA  |
| Creation tx: `0xa4858028aa0738c9b6d205c54ee8550484dd386f90af82ce2c50b9bbad051a0d` |      |

---

## Security Observations

### Positive Findings

1. **No EOAs hold direct privileged roles on the vault.** All role holders are either multisig contracts (Gnosis Safe) or a TimelockController. This is good practice.

2. **Proxy upgrades are behind a 24-hour timelock.** The ProxyAdmin is owned by a `TimelockController` (`0xb5b5...c36B`) with a minimum delay of 86400 seconds (24 hours). Upgrades must be proposed by the 3/5 Admin Safe and wait 24 hours before execution.

3. **Sensitive configuration changes (provider, assets, processor rules) require the timelock.** The `PROVIDER_MANAGER_ROLE`, `ASSET_MANAGER_ROLE`, and `PROCESSOR_MANAGER_ROLE` are assigned to the 24-hour TimelockController, adding a delay before these changes take effect.

4. **Pause/unpause separation.** The `PAUSER_ROLE` is held by a dedicated 2/3 multisig (lower threshold for emergency response), while `UNPAUSER_ROLE` requires the more secure 3/5 Admin Safe.

### Concerns and Risks

1. **BUFFER_MANAGER_ROLE held by both timelock AND Admin Safe directly.** The 3/5 Admin Safe (`0xfcad...6975`) can change the buffer strategy immediately without the 24-hour timelock delay. This bypasses the timelock protection for a critical configuration parameter.

2. **HOOKS_MANAGER_ROLE held by Admin Safe without timelock.** The hooks contract can be changed immediately by the 3/5 Safe. Since hooks can intercept deposit/withdraw/transfer operations, this is a sensitive parameter that could benefit from timelock protection.

3. **ASSET_WITHDRAWER_ROLE held by Admin Safe without timelock.** This role presumably allows withdrawing assets from the vault, which is a highly sensitive operation with no timelock delay.

4. **FEE_MANAGER_ROLE held by Admin Safe without timelock.** Fee parameters can be changed immediately by the 3/5 Safe without a mandatory waiting period.

5. **Processor Safe threshold is only 2/5.** The `PROCESSOR_ROLE` (which can execute arbitrary calls through `processor()`) requires only 2 out of 5 signers. While processor calls are constrained by processor rules set via the timelock, the low threshold presents additional risk if rules are overly permissive.

6. **Overlapping Safe owners.** Three EOAs (`0xDD62...`, `0x92cf...`, `0x6A7F...`) are owners of all three Safes. A compromise of these three keys would give an attacker control over all multisig operations simultaneously (Admin Safe 3/5, Processor Safe 2/5, and Pauser Safe 2/3).

7. **Vault has PROCESSOR_MANAGER_ROLE on itself.** The vault contract itself holds `PROCESSOR_MANAGER_ROLE`, meaning it can call `setProcessorRule()` on itself. This is likely an implementation detail for internal accounting but should be noted.

8. **Admin Safe controls the TimelockController.** The 3/5 Admin Safe holds all timelock roles (proposer, executor, canceller, and default admin). It could potentially modify the timelock's min delay or grant timelock roles to other addresses.
