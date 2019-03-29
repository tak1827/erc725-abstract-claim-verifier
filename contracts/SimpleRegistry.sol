pragma solidity ^0.5.0;

import "openzeppelin-solidity/contracts/ownership/Ownable.sol";
import "./AbstractClaimVerifier.sol";
import "./ClaimHolder.sol";

contract SimpleRegistry is Ownable{

    string private document;

    AbstractClaimVerifier public claimVerifier;

    constructor (AbstractClaimVerifier _claimVerifier) public {
        claimVerifier = _claimVerifier;
    }
    
    // Read document
    // Member identity is allowed to access
    function read() public returns(string memory) {
        ClaimHolder identity = ClaimHolder(msg.sender);
        require(claimVerifier.checkClaim(identity, msg.sig));
        
        return document;
    }

    // Write document
    // Member plus Manager identity is allowed to access
    function write(string memory _document) public {
        ClaimHolder identity = ClaimHolder(msg.sender);
        require(claimVerifier.checkClaim(identity, msg.sig));
        
        document = _document;
    }
    
    // Change ConcreteClaimVerifier contract
    function changeVerifier(AbstractClaimVerifier _claimVerifier) public onlyOwner {
        claimVerifier = _claimVerifier;
    }
}
