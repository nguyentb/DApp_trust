module.exports = {
  // Setting up the Blockchain network for the project.
  // We use Ganache for establishing the local Ethereum network
  networks: {
    development: {
      host: "127.0.0.1",
      port: 7545,
      network_id: "*"
    },
    test: {
      host: "127.0.0.1",
      port: 7545,
      network_id: "*"
    }
  }  
};
