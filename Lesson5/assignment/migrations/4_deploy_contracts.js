var SafeMath = artifacts.require("./SafeMath.sol");
var PayRoll = artifacts.require("./PayRoll.sol");
var Ownable = artifacts.require("./Ownable.sol");


module.exports = function(deployer) {

  deployer.deploy(SafeMath);

  deployer.deploy(Ownable);

  deployer.link(SafeMath, PayRoll);

    deployer.deploy(PayRoll);
};
