const {waffle, ethers} = require('hardhat');
const {constants, utils, BigNumber, getContractFactory} = ethers;
const {deployContract, link, createFixtureLoader, provider} = waffle;

async function initContracts([deployer]) {
  const GameeVouchers = await getContractFactory('GameeVouchers');
  const gameeVouchers = await GameeVouchers.deploy(constants.AddressZero);
  await gameeVouchers.deployed();

  const vouchers = ['1000', '500', '10'];

  for (const voucher of vouchers) {
    await gameeVouchers.createCollection(utils.parseEther(voucher));
  }

  return {
    contracts: {
      gameeVouchers,
    },
    params: {
      vouchers,
    },
  };
}

module.exports = {
  initContracts,
};
