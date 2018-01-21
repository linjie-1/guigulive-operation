// Allows us to use ES6 in our migrations and tests.
require('babel-register')
require('babel-polyfill')

module.exports = {
    networks: {
        development: {
            host: "127.0.0.1",
            port: 9545,
            network_id: "*", // Match any network id
        }
    }
};
