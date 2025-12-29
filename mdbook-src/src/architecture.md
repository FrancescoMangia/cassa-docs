# Architecture

## Components

### 1. Policy Contracts (`ICassaPolicy`)

Define insurance coverage terms:
- **Effective Date**: When coverage begins
- **Expiration Date**: When coverage ends  
- **Settlement Ratio**: Algorithmic payout calculation on claims

### 2. ITUT Vault (`ICassaITUT`)

Manages token pairs:
- **IT (Insured Token)**: Represents insured position
- **UT (Underwriting Token)**: Represents underwriter capital
- **Deposits/Withdrawals**: User capital flows
- **Redemptions**: Policy settlements and early exits

### 3. AMM (`ICassaAMM`)

Provides continuous liquidity:
- **Swaps**: Exchange between ASSET, UNDERLYING, and INSURED tokens
- **Liquidity Provision**: Add/remove liquidity
- **Fees**: Swap fees in parts per million (ppm)

### 4. Token Contracts (`ICassaERC20`)

ERC20 tokens with:
- Mint/burn capabilities
- Allowance management
- Integration with ITUT vault

## Key Concepts

### Settlement

At policy expiration, the settlement ratio determines payouts:
- `ratio = 1e18` (100%): Full payout to IT holders
- `ratio = 0`: Full value to UT holders (no claim)
- `0 < ratio < 1e18`: Proportional split

### AMM Token Types

- **ASSET**: The underlying collateral token
- **UNDERLYING**: Token representing baseline value
- **INSURED**: Token with insurance coverage
