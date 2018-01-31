var Payroll = artifacts.require("./Payroll.sol");
var SafeMath = artifacts.require("./SafeMath.sol");
module.exports = function(deployer) {
    deployer.deploy(SafeMath);
    deployer.link(SafeMath, Payroll);
    deployer.deploy(Payroll);
}
