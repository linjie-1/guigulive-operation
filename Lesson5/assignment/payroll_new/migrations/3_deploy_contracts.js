
var ConvertLib = artifacts.require("./ConvertLib.sol");
var MetaCoin = artifacts.require("./MetaCoin.sol");


module.exports = function(deployer) {
  deployer.deploy(ConvertLib);

  //DEPLOYER.LINK(LIBRARY, DESTINATIONS)
  deployer.link(ConvertLib, MetaCoin);
  deployer.deploy(MetaCoin);
};
