var Ownable = artifacts.require("./lab/Ownable.sol");
var SafeMath = artifacts.require("./lab/SafeMath.sol");
var Payroll = artifacts.require("./Payroll.sol");
module.exports = function(deployer) {
  deployer.deploy(Ownable);
  deployer.deploy(SafeMath);
  deployer.link(Ownable, Payroll);
  deployer.deploy(Payroll);
};
