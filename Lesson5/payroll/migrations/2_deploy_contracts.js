var SafeMath = artifacts.require("./SafeMath.sol");
var Owner = artifacts.require("./Owner.sol");
var Payroll = artifacts.require("./Payroll.sol");

module.exports = function(deployer) {
  deployer.deploy(SafeMath);
  deployer.deploy(Owner);

  deployer.link(SafeMath, Payroll);
  // deployer.link(Owner, Payroll);
  deployer.deploy(Payroll);
};
