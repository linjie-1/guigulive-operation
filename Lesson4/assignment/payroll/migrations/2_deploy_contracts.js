var SimpleStorage = artifacts.require("./SimpleStorage.sol");

module.exports = function(deployer) {
  deployer.deploy(SimpleStorage);
};

var PayrollMigrations = artifacts.require("./Payroll.sol");

module.exports = function(deployer) {
  deployer.deploy(PayrollMigrations);
};

var OwnableMigrations = artifacts.require("./Ownable.sol");

module.exports = function(deployer) {
  deployer.deploy(OwnableMigrations);
};

var SafeMathMigrations = artifacts.require("./SafeMath.sol");

module.exports = function(deployer) {
  deployer.deploy(SafeMathMigrations);
};