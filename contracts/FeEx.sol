pragma solidity >=0.4.25 <0.7.0;
contract FeEx {
    struct FeExStrut {
        string transID;
        uint expValue;
        uint fbScore;
        bool perFlag;
    }

    uint private co_threshold;
    uint private unco_threshold;
    //state variable storing all experience information
    mapping (address => mapping (address => FeExStrut) ) public FeExInfo;

	event Feeback(address indexed _trustor, address indexed _trustee, string _transID, uint _fbScore);

    constructor() public {
        // set feedback score in the range [1-100]
		co_threshold = 75;
        unco_threshold = 60;
	}

	function giveFeedback(address trustee, string memory transID, uint fbScore) public returns(bool success) {
		//validate whether the sender has permission to give feedback to the trustee
        if (keccak256(abi.encodePacked(FeExInfo[msg.sender][trustee].transID)) != keccak256(abi.encodePacked(transID))) return false;
        if (FeExInfo[msg.sender][trustee].perFlag == false) return false;

        //update the feedback score
        FeExInfo[msg.sender][trustee].fbScore = fbScore;
        //mark that the feedback has been conducted which won't allow another feedback
        FeExInfo[msg.sender][trustee].perFlag = false;

        uint new_expValue;
        //update the expValue
        if (fbScore >= co_threshold) {
            //update expValue based on increase model
            new_expValue = 1000;
        } else if (fbScore < unco_threshold) {
            //update expValue based on decrease model
            new_expValue = 700;
        } else {
            //update expValue based on decay model
            new_expValue = 100;
        }
        FeExInfo[msg.sender][trustee].expValue = new_expValue;

        emit Feeback(msg.sender, trustee, transID, fbScore);

		return true;
	}

    //function to enable permission for a trustor to give feedback to a trustee
    function setFeExInfo(address trustor, address trustee, string calldata transID) external returns(bool success) {
        FeExInfo[trustor][trustee].transID = transID;
        FeExInfo[trustor][trustee].perFlag = true;
        return true;
    }

}
