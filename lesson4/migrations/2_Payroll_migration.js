var PayrollMigrations = artifacts.require("./Payroll.sol");

module.exports = function(deployer) {
  deployer.deploy(PayrollMigrations);
};
