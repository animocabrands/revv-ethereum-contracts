const {waffle, ethers} = require('hardhat');
const {constants, utils, BigNumber, getContractFactory} = ethers;
const {deployContract, link, createFixtureLoader, provider} = waffle;

async function initContracts([deployer, purchaser, payout]) {
  const GameeVouchers = await getContractFactory('GameeVouchers');
  const gameeVouchers = await GameeVouchers.deploy(constants.AddressZero);
  await gameeVouchers.deployed();

  return {
    contracts: {
      gameeVouchers,
    },
    params: {},
  };
}

module.exports = {
  initContracts,
};
