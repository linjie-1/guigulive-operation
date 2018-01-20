var Payroll = artifacts.required("./Payroll.sol");

module.exports = function(deployer) {
    deployer.deploy(Payroll);
}
