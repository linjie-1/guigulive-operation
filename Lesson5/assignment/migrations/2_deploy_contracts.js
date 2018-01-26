var Ownable = artifacts.require("./Ownable.sol");
var SafeMath = artifacts.require("./SafeMath.sol");
var Payroll = artifacts.require("./Payroll.sol");

module.exports = function(deployer, network, accounts) {
  deployer.deploy(Ownable);
  deployer.deploy(SafeMath);

  deployer.link(Ownable, Payroll);
  deployer.link(SafeMath, Payroll);
  deployer.deploy(Payroll);
};
