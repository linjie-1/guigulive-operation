var Payroll = artifacts.require("./Payroll.sol");

module.exports = function(deployer) {
  deployer.deploy(Payroll);
};
