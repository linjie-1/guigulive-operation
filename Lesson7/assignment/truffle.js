var HDWalletProvider = require("truffle-hdwallet-provider");

var mnemonic = "opinion destroy betray betray betray betray betray betray betray betray betray betray";

module.exports = {
  networks: {
    migration_directory: "./migrations",
    ropsten: {
      provider: function() {
        return new HDWalletProvider(mnemonic, "https://ropsten.infura.io/TT6uQQrXNKFq26wxSqjG")
      },
      network_id: 3,
    }
  }
};
