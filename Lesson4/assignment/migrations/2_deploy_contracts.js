var SimpleStorage = artifacts.require("./SimpleStorage.sol");
var Payroll = artifacts.require("./payroll.sol");


module.exports = function(deployer) {
  deployer.deploy(SimpleStorage);

  deployer.deploy(Payroll);
};
