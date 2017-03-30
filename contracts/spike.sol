pragma solidity ^0.4.9;

contract Claim {

    string public claim;

    event ClaimMade(address indexed _from, address indexed _target, string _claimId);

    function attest(address _target, string _claimId) {
        claim = _claimId;
        ClaimMade(msg.sender, _target, _claimId);
    }
}

//    mapping (address => mapping (address => bool)) claimExistsTo;
//    mapping (address => mapping (address => bool)) claimExistsFrom;
//    
//    mapping (address => string[]) claimsTo;
//    mapping (address => string[]) claimsFrom;
//
//    function attest(address _to, string _claimId) {
//        claimExistsTo[_to][msg.sender][_claimId] = true;
//        
//        claimExistsFrom[msg.sender][_to][_claimId] = true;
//
//        // arrays: 
//    
//        claimsTo[_to].push(_claimId);
//        
//        claimsFrom[msg.sender].push(_claimId);
//    }
//}


//contract Status {
//    mapping (address => string) statuses;
//
//    function updateStatus(string status) {
//        statuses[msg.sender] = status;
//    }
//
//    function getStatus(address addr) returns(string) {
//        return statuses[addr];
//    }
//}
