# Policies

## Overview

Policies in Cassa are fully algorithmic contracts that define insurance terms without requiring governance or human arbiters.

## Policy Lifecycle

1. **Creation**: Policy contract deployed with terms
2. **Active Period**: Coverage is in effect (between effective and expiration dates)
3. **Settlement**: Algorithmic calculation of settlement ratio
4. **Redemption**: Users redeem tokens based on settlement ratio

## Settlement Mechanism

The settlement ratio is a value between 0 and 1e18 (representing 0% to 100%):

```
settlementRatio = claimPayout / totalCoverage
```

This ratio determines the split between IT and UT holders at redemption.

## Key Features

- **Deterministic**: No human intervention in settlement
- **Transparent**: All terms encoded in smart contract
- **Immutable**: Once set, settlement ratios cannot be changed
- **Composable**: Policies can be combined and traded in secondary markets
