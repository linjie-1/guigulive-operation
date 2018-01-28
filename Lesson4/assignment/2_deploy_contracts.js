//var SimpleStorage = artifacts.require("./SimpleStorage.sol");
var Payroll = artifacts.require("./Payroll.sol");

module.exports = function(deployer) {
  //deployer.deploy(SimpleStorage);
  //deployer.deploy(SafeMath);
  //deployer.deploy(Ownable);
  //deployer.link(SafeMath,Payroll);   
  deployer.deploy(Payroll);
  
};