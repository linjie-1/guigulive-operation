var SimpleStorage = artifacts.require("./SimpleStorage.sol");
// var Ownable = artifacts.require("./libs/Ownable.sol");
// var SafeMath = artifacts.require("./libs/SafeMath.sol");
var Payroll = artifacts.require("./Payroll.sol");

module.exports = function(deployer) {
  deployer.deploy(SimpleStorage);
  // deployer.deploy(Ownable);
  // deployer.deploy(SafeMath);
  // deployer.link(Ownable, Payroll);
  // deployer.link(SafeMath, Payroll);
  deployer.deploy(Payroll);
};
