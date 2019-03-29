const MemberVerifier = artifacts.require("./verifier/MemberVerifier.sol");
const ManagerVerifier = artifacts.require("./verifier/ManagerVerifier.sol");
const Web3 = require('web3')

const keyType = 1    // ECDSA
const keyPurpose {
  member: 4,         // Member Verification
  manager: 5         // Manager Verification
}

module.exports = async function(deployer) {

	// Deploy contracts
  const memberVerifier = await deployer.deploy(MemberVerifier);
  const managerVerifier = await deployer.deploy(ManagerVerifier);

  // Add mamber claim sign key
  const accounts = await getAccounts()
  const memberClaimIssuer = accounts[1]
  await memberVerifier.addKey(
    web3.utils.soliditySha3(memberClaimIssuer), keyPurpose.member, keyType)

  // Add manager claim sign key
  const managerClaimIssuer = accounts[2]
  await managerVerifier.addKey(
    web3.utils.soliditySha3(managerClaimIssuer), keyPurpose.manager, keyType)
};

const getAccounts = () => (new Promise((resolve, reject) => {
	web3.eth.getAccounts((error, result) => {
    if (error) {
      reject(err)
    }
    resolve(result)
  })
}))
