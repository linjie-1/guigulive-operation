var SafeMath = artifacts.require("zeppelin-solidity/contracts/math/SafeMath.sol");
var Ownable = artifacts.require("zeppelin-solidity/contracts/ownership/Ownable.sol")
var Payroll = artifacts.require("./Payroll.sol");

module.exports = function(deployer) {
  deployer.deploy(SafeMath);
  deployer.deploy(Ownable);

  deployer.link(SafeMath, Payroll);  
  deployer.link(Ownable, Payroll);
  deployer.deploy(Payroll);
};
