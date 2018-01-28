var payroll = artifacts.require("./Payroll.sol");


module.exports = function(deployer) {
  deployer.deploy(payroll);
};
