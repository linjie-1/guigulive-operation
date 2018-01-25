var ConvertLib = artifacts.require("./ConvertLib.sol");
var MetaCoin = artifacts.require("./MetaCoin.sol");
var Ownable = artifacts.require("./Ownable");
var SafeMath = artifacts.require("./SafeMath");
var Payroll = artifacts.require("./Payroll.sol");

module.exports = function(deployer) {
  deployer.deploy(ConvertLib);
  deployer.link(ConvertLib, MetaCoin);
  deployer.deploy(MetaCoin);
  deployer.link(SafeMath, Ownable, Payroll);
  deployer.deploy(Payroll);
};
