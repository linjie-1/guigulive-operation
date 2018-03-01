# payroll

A payroll system developed with React and Solidty for Ethereum Blockchain platform. 

## Get Started

1. Install dependencies `npm install -g truffle ethereumjs-testrpc`
1. Install [Metamask](https://metamask.io/)
1. Run `testrpc`
1. Add first account in testrpc to Metamask by importing private key
1. Run `truffle compile` in the project directory
1. `truffle migrate`
1. `npm run start`


## homework Info

1. contract address: 0x6dADafa82eaA4d08dd61421F45AC9Cef2182DF16

2. modify files:

- contracts/payroll.sol: add events about NewEmployee, UpdateEmployee, RemoveEmployee, NewFund, GetPaid.

- src/common.js: uncomment lines in "componentDidMount" function

3. snapshots:

- testrpc_snapshot.jpg: the 10 accounts and private keys; the first account is owner.

- add_fund.jpg: owner add fund into the contract

- add employee.jpg: owner add new employee into the contract

- employee get paid.jpg: employee get paid
