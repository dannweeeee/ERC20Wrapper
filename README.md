# ERC20 Wrapper + ETH Wrapper
**Project #3 for Arcane x CertiK Developer Workshop** <br>
<br>
Problem Statement: https://github.com/yieldprotocol/mentorship2022/issues/3
<br>

## ERC20 Wrapper
Users can exchange ERC20 TokenA for ERC20 TokenB via a contract called Wrapper. Wrapper contract will do a 1 for 1 exchange.

### Objectives
1. Users can send a pre-specified ERC20 token to a Wrapper contract (also an ERC20).
2. Wrapper contract issues an equal number of Wrapper tokens to the sender.
3. Holder of wrapper tokens can claim their original ERC20 tokens, by burning wrapped tokens.

## ETH Wrapper
Ether is not an ERC-20 token, while being the native token for Ethereum. This forces all platforms to implement Ether as an edge case. 

### Objectives
1. Code a Wrapper that takes Ether as it's currency.
