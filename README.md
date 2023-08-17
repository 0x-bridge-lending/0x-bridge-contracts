# Zero Bridge

### Sample Hardhat Project

This project demonstrates a basic Hardhat use case. It comes with a sample contract, a test for that contract, and a script that deploys that contract.

Try running some of the following tasks:

```shell
npx hardhat help
npx hardhat test
REPORT_GAS=true npx hardhat test
npx hardhat node
npx hardhat run scripts/deploy.js
```
## Contracts

Zero Bridge is a smart contract to make a deposit for get a loan on starknet l2
The contract supports GHO deposits and its connected to Aave

throught zk proofs we validate that the user has a valid deposit on our contract
and asign a loan on starknet blockchain
