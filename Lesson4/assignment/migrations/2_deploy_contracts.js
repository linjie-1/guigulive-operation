var SimpleStorage = artifacts.require("./SimpleStorage.sol");
var Payroll = artifacts.require("./payroll.sol");
var SafeMath = artifacts.require("./SafeMath.sol");
var Ownable = artifacts.require("./Ownable.sol");

module.exports = function(deployer) {
  deployer.deploy(SimpleStorage);
  deployer.deploy(Ownable);
  deployer.deploy(SafeMath);
  deployer.link(Ownable, Payroll);
  deployer.link(SafeMath, Payroll);
  deployer.deploy(Payroll);
};


