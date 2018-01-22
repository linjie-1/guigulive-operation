var Payroll = artifacts.require("./payroll.sol");

module.exports = function(deployer) {
  deployer.deploy(Payroll);
};