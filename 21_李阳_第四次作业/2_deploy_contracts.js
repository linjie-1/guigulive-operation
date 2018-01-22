var Payroll = artifacts.require("./Payroll.sol");
var Safemath = artifacts.require("./SafeMath.sol");
var Ownable = artifacts.require("./Ownable.sol");

module.exports = function(deployer) {
  deployer.deploy(Safemath);
  deployer.deploy(Ownable);
  deployer.link(Safemath, Payroll);
  deployer.link(Ownable, Payroll);
  deployer.deploy(Payroll);
};