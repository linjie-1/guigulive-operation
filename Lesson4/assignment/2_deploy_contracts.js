var SafeMath = artifacts.require("./SafeMath.sol");
var Ownable = artifacts.require("./Ownable.sol");
var Payroll = artifacts.require("./Payroll.sol");


module.exports = function(deployer) {
  deployer.deploy(SafeMath);
  deployer.deploy(Ownable);
  deployer.link(SafeMath,Payroll);
  deployer.deploy(Payroll);
};
