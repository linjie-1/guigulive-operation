var SimpleStorage = artifacts.require("./SimpleStorage.sol");
var Payroll = artifacts.require("Payroll");

module.exports = function(deployer) {
    deployer.deploy(SimpleStorage);
    deployer.deploy(Payroll);
};
