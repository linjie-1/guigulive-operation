var Migrations = artifacts.require("./Migrations.sol");
var Mypayroll = artifacts.require("./Mypayroll.sol");
var Ownable = artifacts.require("./libs/Ownable.sol");
var SafeMath = artifacts.require("./libs/SafeMath.sol");

module.exports = function(deployer) {
  deployer.deploy(Migrations);

  deployer.deploy(Mypayroll);
  deployer.deploy(Ownable);
  deployer.deploy(SafeMath);
};
