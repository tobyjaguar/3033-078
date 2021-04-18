module.exports = {
  // See <http://truffleframework.com/docs/advanced/configuration>
  // to customize your Truffle configuration!
  networks: {
    development: {
      host: "localhost",
      port: 8545,
      network_id: "*",
      gas: 100000000
    },
  },
  compilers: {
    solc: {
      version: "0.5.16",
      parser: "solcjs",
      settings: {
        optimizer: {
          enabled: true,
          runs: 5 //500
        },
        evmVersion: "istanbul"
      }
    }
  }
};
