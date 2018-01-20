var SafeMathLib = artifacts.require("./SafeMath.sol");
var OwnableLib = artifacts.require("./Ownable.sol");
var EnhancedPayroll = artifacts.require("./EnhancedPayroll.sol");

module.exports = function(deployer) {
  deployer.deploy(SafeMathLib);
  deployer.deploy(OwnableLib);
  deployer.link(SafeMathLib, EnhancedPayroll);
  deployer.link(OwnableLib, EnhancedPayroll);
  deployer.deploy(EnhancedPayroll);
};
