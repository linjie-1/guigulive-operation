var Payroll = artifacts.require("./Payroll.sol");

module.exports = function(deployer, network, accounts) {
  deployer.deploy(Payroll, {from: accounts[0]});
};
