var SimpleStorage = artifacts.require("./SimpleStorage.sol");
var Ownable = artifacts.require("./Ownable.sol");
var SafeMath = artifacts.require("./SafeMath.sol");
var Payroll = artifacts.require("./Payroll.sol");

module.exports = function(deployer) {
  deployer.deploy(SimpleStorage);
  deployer.deploy(Ownable);
  deployer.link(Ownable, Payroll);
  deployer.deploy(SafeMath);
  deployer.link(SafeMath, Payroll);
  deployer.deploy(Payroll);
};
