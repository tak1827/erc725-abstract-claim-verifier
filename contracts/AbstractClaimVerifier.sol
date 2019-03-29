pragma solidity ^0.5.0;

import "./ClaimHolder.sol";

contract AbstractClaimVerifier {

    event ClaimValid   (ClaimHolder indexed identity, uint256 topic);
    event ClaimInvalid (ClaimHolder indexed identity, uint256 topic);
    
    // Abstract checkClaim function
    function checkClaim(ClaimHolder _identity, bytes4 _funcSig) public returns (bool) {}

    function claimIsValid(ClaimHolder _identity, ClaimHolder _trustedClaimHolder, uint256 topic)
        public
        view
        returns (bool claimValid)
    {
        uint256 foundTopic;
        uint256 scheme;
        address issuer;
        bytes memory sig;
        bytes memory data;

        // Construct claimId (identifier + claim type)
        bytes32 claimId = keccak256(abi.encodePacked(_trustedClaimHolder, topic));

        // Fetch claim from user
        ( foundTopic, scheme, issuer, sig, data, ) = _identity.getClaim(claimId);

        bytes32 dataHash = keccak256(abi.encodePacked(_identity, topic, data));
        bytes32 prefixedHash = keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", dataHash));

        // Recover address of data signer
        address recovered = getRecoveredAddress(sig, prefixedHash);

        // Take hash of recovered address
        bytes32 hashedAddr = keccak256(abi.encodePacked(recovered));

        // Does the trusted identifier have they key which signed the user's claim?
        return _trustedClaimHolder.keyHasPurpose(hashedAddr, 3);
    }

    function getRecoveredAddress(bytes memory sig, bytes32 dataHash)
        public
        pure
        returns (address addr)
    {
        bytes32 ra;
        bytes32 sa;
        uint8 va;

        // Check the signature length
        if (sig.length != 65) {
            return address(0);
        }

        // Divide the signature in r, s and v variables
        assembly {
            ra := mload(add(sig, 32))
            sa := mload(add(sig, 64))
            va := byte(0, mload(add(sig, 96)))
        }

        if (va < 27) {
            va += 27;
        }

        address recoveredAddress = ecrecover(dataHash, va, ra, sa);

        return (recoveredAddress);
    }

}
