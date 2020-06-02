pragma solidity >=0.4.25 <0.7.0;

import "./ConvertLib.sol";


contract IpfsCoin {
	mapping (address => uint) balances;

	event Transfer(address indexed _from, address indexed _to, uint256 _value);

	constructor() public {
		balances[tx.origin] = 10000;
	}

	function sendCoin(address receiver, uint amount) public returns(bool sufficient) {
		if (balances[msg.sender] < amount) return false;
		balances[msg.sender] -= amount;
		balances[receiver] += amount;
		emit Transfer(msg.sender, receiver, amount);

		//call the FeEx smartcontract to update the permission to give feedback
		FeEx feExIns = FeEx(feExaddr);
		feExIns.setFeExInfo(msg.sender, receiver, )
		return true;
	}

	function getBalanceInEth(address addr) public view returns(uint){
		return ConvertLib.convert(getBalance(addr),2);
	}

	function getBalance(address addr) public view returns(uint) {
		return balances[addr];
	}
}

//call the FeEx smart contract
interface FeEx {
	function setFeExInfo(address trustor, address trustee, string calldata transID) external returns(bool);
}