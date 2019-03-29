const ConcreteClaimVerifier = artifacts.require("./ConcreteClaimVerifier.sol");
const CanvasRegistry = artifacts.require("./SimpleRegistry.sol");

module.exports = async function(deployer) {
  const verifier = await deployer.deploy(ConcreteClaimVerifier);
  await deployer.deploy(SimpleRegistry, verifier.address);
};
