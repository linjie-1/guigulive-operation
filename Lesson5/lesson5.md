# Lesson 5

## Truffle Workflow

1. Get all the contracts done

2. Edit deploy_contracts.js

Example

```
var Ownable = artifacts.require("./Ownable.sol");
var SafeMath = artifacts.require("./SafeMath.sol");
var Payroll = artifacts.require("./Payroll.sol");

module.exports = function(deployer) {
  deployer.deploy(Ownable);
  deployer.deploy(SafeMath);

  deployer.link(Ownable, Payroll);
  deployer.link(SafeMath, Payroll);
  deployer.deploy(Payroll);
};
```

3. compile

```
truffle compile
```

4. Test with `truffle develop`

```
truffle develop
truffle(develop)>migrate
truffle(develop)>web3.eth.accounts
```