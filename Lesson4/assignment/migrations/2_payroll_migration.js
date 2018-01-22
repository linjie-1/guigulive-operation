var PayRoll = artifacts.require("./PayRoll.sol");

module.exports = function(deployer) {
  deployer.deploy(PayRoll);
};
