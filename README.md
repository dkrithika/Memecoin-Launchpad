# Memecoin Factory Launchpad

A minimal launchpad for memcoins where users can buy tokens directly from a sale contract. 
A solidity factory for launching memecoins. Anyone pays a fee to create a 1M token supply ERC-20, then others buy during the open sale. **No automatic liquidity pool**. Unsold tokens + raised ETH return to the **token creator** (not factory owner)

## 🚀 Quick Demo

1. Pay fee → `create("DogeKing", "DGK")`
2. Others buy → `buy(tokenAddress, 1000e18)` (price rises every 10k tokens)
3. Sale auto-closes at 500k tokens or 3 ETH raised
4. Creator calls `deposit(token)` to reclaim unsold tokens + ETH

## 📊 Key Specs

| Feature | Details |
|---------|---------|
| **Token Supply**  | 1,000,000 (1M) per token, 18 decimals   |
| **Sale Limit**    | 500,000 tokens OR 3 ETH raised          |
| **Creator Gets**  | Unsold tokens + all raised ETH          |
| **Factory Owner** | Collects creation fees via `withdraw()` |
| **No LP**         | Creator must add liquidity manually post-sale |

## 🛠 Contract Functions

### Create Token
- Pays `fee` (set at deploy)
- Deploys new ERC-20 Token contract
- Opens sale automatically
- Emits `Created(token)`

### Buy Tokens
- Calculates rising price via `getCost(sold)`
- Transfers tokens to buyer
- Tracks `sold`/`raised`
- Auto-closes if limits hit
- Emits `Buy(token, amount)`

### Claim Funds (Creator Only)
- Only after sale closes (`!isOpen`)
- Sends remaining tokens to `creator`
- Sends raised ETH to `creator`

### Owner Withdraw
- Factory owner pulls creation fees

## 🔧 Local Testing (Foundry/Hardhat)


## ⚠️ Warnings
- **Rug Risk**: Creator controls unsold tokens/ETH
- **No LP**: Tokens untradeable until creator adds DEX liquidity
- **Gas**: Optimized for ^0.8.28
- **Audit Needed**: For production use

## 🤝 Contributing

1. Fork the repo & clone locally
2. Create your feature branch (`git checkout -b feature/amazing-fix`)
3. Commit changes (`git commit -m 'Add amazing fix'`)
4. Push & create Pull Request

**Test everything**: `forge test`

## 📄 License
MIT


