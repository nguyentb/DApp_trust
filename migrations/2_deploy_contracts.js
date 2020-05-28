const ConvertLib = artifacts.require("ConvertLib");
const IpfsCoin = artifacts.require("IpfsCoin");

module.exports = function(deployer) {
  deployer.deploy(ConvertLib);
  deployer.link(ConvertLib, IpfsCoin);
  deployer.deploy(IpfsCoin);
};
