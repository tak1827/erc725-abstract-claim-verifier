pragma solidity ^0.5.0;

import "./AbstractClaimVerifier.sol";
import "./ClaimHolder.sol";

contract ConcreteClaimVerifier is AbstractClaimVerifier {
    
    bytes4 public readFuncSig = 0x57de26a4;
    bytes4 public writeFuncSig = 0xebaac771;
    
    ClaimHolder public memberVerifier;
    ClaimHolder public managerVerifier;
    
    // Concrete checkClaim function
    function checkClaim(ClaimHolder _identity, bytes4 _funcSig) 
        public 
        returns (bool) 
    {
        
        // Called from read function
        if (_funcSig == readFuncSig) {
            
            // Member identity is allowed to access
            if (checkMemberClaim(_identity, 1)) {
                return true;
            } else {
                return false;
            }
            
        // Called from write function
        } else if (_funcSig == writeFuncSig) {
            
            // Member plus Manager identity is allowed to access
            if (checkMemberClaim(_identity, 1) && checkManagerClaim(_identity, 2)) {
                return true;
            } else {
                return false;
            }
        }
        
    }
    
    // Check whether having member claim
    function checkMemberClaim(ClaimHolder _identity, uint256 claimType) 
        private 
        returns (bool) 
    {
        if (claimIsValid(_identity, memberVerifier, claimType)) {
            emit ClaimValid(_identity, claimType);
            return true;
        } else {
            emit ClaimInvalid(_identity, claimType);
            return false;
        }
    }
    
    // Check whether having manager claim
    function checkManagerClaim(ClaimHolder _identity, uint256 claimType) 
        private 
        returns (bool) 
    {
        if (claimIsValid(_identity, managerVerifier, claimType)) {
            emit ClaimValid(_identity, claimType);
            return true;
        } else {
            emit ClaimInvalid(_identity, claimType);
            return false;
        }
    }
}
