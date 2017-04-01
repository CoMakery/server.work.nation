pragma solidity ^0.4.9;


contract Claims {

    mapping (address => string[]) public claims;

    mapping (string => address[]) claimConfirmers;

    mapping (address => address[]) public trusted;

    function whoami() returns (address) {
        return msg.sender;
    }

    function claim(string _claimId) {
        claims[msg.sender].push(_claimId);
    }

    function confirm(string _claimId, address claimant) {
    // TODO reject confirm of self
        claimConfirmers[_claimId].push(msg.sender);
        trusted[msg.sender].push(claimant);
    }

    function getClaimConfirmers(string _claimId) returns (address[] confirmers) {
        return claimConfirmers[_claimId];
    }

    function getTrustedClaims(address[] peeps, int8 depth) returns (address[]) {
        return trusted[msg.sender];
    //        Return ppl if depth == 0
    //        //newPpl = trusted[msg.sender]
    //        //walk addresss trusted; 
    //        For person in ppl {
    //              getTrustedClaims(depth - 1)
    //        }
    //        getClaims(address);
    //        getClaimConfirmers(ipfs-claim)
    }
}


//contract Claim {
//
//    string public claim;
//
//    event ClaimMade(address indexed _from, address indexed _target, string _claimId);
//
//    function attest(address _target, string _claimId) {
//        claim = _claimId;
//        ClaimMade(msg.sender, _target, _claimId);
//    }
//}


// alice claims "alice used ROR on project X" (Claim C)
// bob confirms Claim C
// now, alice's further confirmations are trusted by Bob


//  P <- [[claim]] -> P
//
//  claim <- [[confirmation]] -> Q
//
//  Q <- [trusted to confirm] <- P

// maybe:
//  Q <- [NOT trusted to confirm] <- P

// search for RoR in my network:
// 1. search to N levels: people I've confirmed / they've confirmed in anything
// 2. within all those results, find the RoR confirmed claims
// 3. return results: for each person, confirmed wihin my trust network + confirmed outside of network 



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
