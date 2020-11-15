const {waffle, ethers} = require('hardhat');
const {constants, utils, BigNumber, getContractFactory} = ethers;
const {deployContract, link, createFixtureLoader, provider} = waffle;

async function initContracts([deployer, purchaser, payout]) {
  const REVVTrophies = await getContractFactory('REVVTrophies');
  const revvTrophies = await REVVTrophies.deploy(constants.AddressZero);
  await revvTrophies.deployed();

  return {
    contracts: {
      revvTrophies,
    },
    params: {},
  };
}

module.exports = {
  initContracts,
};
