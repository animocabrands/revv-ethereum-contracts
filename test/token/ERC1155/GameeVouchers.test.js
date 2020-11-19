// const {accounts, contract, web3} = require('@openzeppelin/test-environment');
// const {ether, expectEvent, expectRevert} = require('@openzeppelin/test-helpers');
// const {ZeroAddress, Zero, One, Two} = require('@animoca/ethereum-contracts-core_library').constants;
// const {asciiToHex, padLeft, toBN, toHex} = web3.utils;

const {expect} = require('chai');
const {waffle, ethers} = require('hardhat');
const {constants, utils, BigNumber, getContractFactory} = ethers;
const {deployContract, link, createFixtureLoader, provider} = waffle;

const {initContracts} = require('./GameeVouchers.fixtures');

const {EthAddress} = require('../../../src/constants');

const [deployer, recipient, payout] = provider.getWallets();

// This is a workaround as described in https://github.com/nomiclabs/hardhat/issues/849
// import loadFixture from waffle when fixed
const loadFixture = waffle.createFixtureLoader([deployer, recipient, payout], provider);

describe.only('GameeVouchers', function () {
  describe('batchMint()', function () {
    it('should mint for a staker successfully', async function () {
      const {contracts, params} = await loadFixture(initContracts);

      await expect(
        contracts.gameeVouchers.batchMint(
          recipient.address,
          params.vouchers.map((v) => utils.parseEther(v)),
          params.vouchers.map((v) => constants.One),
          '0x'
        )
      )
        .to.emit(contracts.gameeVouchers, 'TransferBatch')
        .withArgs(
          deployer.address,
          constants.AddressZero,
          recipient.address,
          params.vouchers.map((v) => utils.parseEther(v)),
          params.vouchers.map((v) => constants.One)
        );
    });
  });
});
