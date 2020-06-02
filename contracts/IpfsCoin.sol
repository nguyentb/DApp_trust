pragma solidity >=0.4.25 <0.7.0;

import "./ConvertLib.sol";


contract IpfsCoin {
	address feExAddr;
	mapping (address => uint) balances;
	event Transfer(address indexed _from, address indexed _to, uint256 _value);

	constructor() public {
		balances[tx.origin] = 10000;
		feExAddr = 0xb6FB8D2adA0df10277cCe382F2d19236d08F26Bc;
	}

	function sendCoin(address receiver, uint amount) public returns(bool sufficient) {
		if (balances[msg.sender] < amount) return false;
		balances[msg.sender] -= amount;
		balances[receiver] += amount;
		emit Transfer(msg.sender, receiver, amount);

		//call the FeEx smartcontract to update the permission to give feedback
		FeEx feExIns = FeEx(feExAddr);
		feExIns.setFeExInfo(msg.sender, receiver, blockhash(block.number - 1));
		return true;
	}

	function getBalanceInEth(address addr) public view returns(uint){
		return ConvertLib.convert(getBalance(addr),2);
	}

	function getBalance(address addr) public view returns(uint) {
		return balances[addr];
	}

	//for setting up the FeEx contract address
	function setFeExAddr(address _feExAddr) public returns(bool){
		feExAddr = _feExAddr;
		return true;
	}
}

//call the FeEx smart contract
interface FeEx {
	function setFeExInfo(address trustor, address trustee, bytes32 transID) external returns(bool);
}