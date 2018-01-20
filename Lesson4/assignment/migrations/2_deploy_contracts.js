var Payroll = artifacts.require("./Payroll.sol");
var Ownable = artifacts.require("./Ownable.sol");

module.exports = function(deployer) {
  deployer.deploy(Ownable);
  deployer.link(Ownable, Payroll);
  deployer.deploy(Payroll);
};
