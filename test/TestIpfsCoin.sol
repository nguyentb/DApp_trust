pragma solidity >=0.4.25 <0.7.0;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/IpfsCoin.sol";

contract TestIpfsCoin {

  function testInitialBalanceUsingDeployedContract() public {
    IpfsCoin ipfs = IpfsCoin(DeployedAddresses.IpfsCoin());

    uint expected = 10000;

    Assert.equal(ipfs.getBalance(msg.sender), expected, "Owner should have 10000 IpfsCoin initially");
  }

  function testInitialBalanceWithNewIpfsCoin() public {
    IpfsCoin ipfs = new IpfsCoin();

    uint expected = 10000;

    Assert.equal(ipfs.getBalance(msg.sender), expected, "Owner should have 10000 IpfsCoin initially");
  }

}