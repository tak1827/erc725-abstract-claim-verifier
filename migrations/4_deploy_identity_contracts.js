const Member = artifacts.require("./person/Member.sol");
const Manager = artifacts.require("./person/Manager.sol");
const Web3 = require('web3')

const keyPurpose = 3
const keyType = 1

module.exports = async function(deployer) {

	// Deploy contract
  const member = await deployer.deploy(Member);
  const manager = await deployer.deploy(Manager);
};

const getAccounts = () => (new Promise((resolve, reject) => {
	web3.eth.getAccounts((error, result) => {
    if (error) {
      reject(err)
    }
    resolve(result)
  })
}))
