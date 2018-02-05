var SafeMathLib = artifacts.require("./SafeMath.sol");
var OwnableLib = artifacts.require("./Ownable.sol");
var Payroll = artifacts.require("./Payroll.sol");

module.exports = function(deployer) {
  deployer.deploy(SafeMathLib);
  deployer.deploy(OwnableLib);
  deployer.link(SafeMathLib, Payroll);
  deployer.link(OwnableLib, Payroll);
  deployer.deploy(Payroll);
};