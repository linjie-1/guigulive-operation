//var SimpleStorage = artifacts.require("./SimpleStorage.sol");
var Ownable = artifacts.require("./Owable.sol");
var SafeMath = artifacts.require("./SafeMath.sol");
var PayRoll = artifacts.require("./payroll.sol");


module.exports = function(deployer) {
  //deployer.deploy(SimpleStorage);
  deployer.deploy(Ownable);
  deployer.deploy(SafeMath);

  deployer.link(Ownable, PayRoll);
  deployer.link(SafeMath, PayRoll);    
  deployer.deploy(PayRoll);
};
