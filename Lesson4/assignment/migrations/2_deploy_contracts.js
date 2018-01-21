var Payroll = artifacts.require("./Payroll.sol");
var SafeMath = artifacts.require("./SafeMath.sol");
var Ownable = artifacts.require("./Ownable.sol");

module.exports = function(deployer) {
  //deployer.deploy(SafeMath);
  //deployer.deploy(Ownable);
  //deployer.link(SafeMath, PayRoll);
  deployer.deploy(Payroll);
};




