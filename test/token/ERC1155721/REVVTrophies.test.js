// // const {accounts, contract, web3} = require('@openzeppelin/test-environment');
// // const {ether, expectEvent, expectRevert} = require('@openzeppelin/test-helpers');
// // const {ZeroAddress, Zero, One, Two} = require('@animoca/ethereum-contracts-core_library').constants;
// // const {asciiToHex, padLeft, toBN, toHex} = web3.utils;

// const {expect} = require('chai');
// const {waffle, ethers} = require('hardhat');
// const {constants, utils, BigNumber, getContractFactory} = ethers;
// const {deployContract, link, createFixtureLoader, provider} = waffle;

// const {initContracts, initContractsAndMintNft} = require('./REVVTrophies.fixtures');

// const {EthAddress} = require('../../src/constants');

// const [deployer, purchaser, payout, recipient] = provider.getWallets();

// // This is a workaround as described in https://github.com/nomiclabs/hardhat/issues/849
// // import loadFixture from waffle when fixed
// const loadFixture = waffle.createFixtureLoader([deployer, purchaser, payout], provider);

// describe('REVVSale', function () {
//   describe('purchaseFor()', function () {
//     it('reverts if purchaser is not an NFT owner', async function () {
//       const {contracts, params} = await loadFixture(initContracts);
//       console.log(contracts.sale.address);

//       const quantity = constants.Two;
//       const paymentToken = EthAddress;

//       await expect(
//         contracts.sale.connect(purchaser).purchaseFor(purchaser.address, paymentToken, params.sku, quantity, '0x', {
//           value: params.ethPrice.mul(constants.Two),
//         })
//       ).to.be.revertedWith('REVVSale: must be a NFT owner');
//     });

//     it('should purchase successfully with ETH', async function () {
//       const {contracts, params} = await loadFixture(initContractsAndMintNft);
//       console.log(contracts.sale.address);

//       const quantity = constants.One;
//       const paymentToken = EthAddress;

//       await expect(
//         contracts.sale.connect(purchaser).purchaseFor(purchaser.address, paymentToken, params.sku, quantity, '0x', {
//           value: params.ethPrice,
//         })
//       )
//         .to.emit(contracts.sale, 'Purchase')
//         .withArgs(
//           purchaser.address,
//           purchaser.address,
//           paymentToken,
//           params.sku,
//           quantity,
//           '0x',
//           params.ethPrice,
//           [],
//           [],
//           []
//         )
//         .to.emit(contracts.revv, 'Transfer')
//         .withArgs(contracts.sale.address, purchaser.address, utils.parseEther('1'));
//     });

//     for (let i = 0; i < 500; ++i) {
//       it('should purchase successfully with DAI' + i, async function () {
//         const {contracts, params} = await loadFixture(initContractsAndMintNft);
//         console.log(contracts.sale.address);

//         const quantity = constants.One;
//         const paymentToken = contracts.dai.address;
//         await contracts.dai.connect(purchaser).approve(contracts.sale.address, utils.parseEther('100000000'));

//         await expect(
//           contracts.sale.connect(purchaser).purchaseFor(purchaser.address, paymentToken, params.sku, quantity, '0x', {
//             value: params.ethPrice,
//           })
//         )
//           .to.emit(contracts.sale, 'Purchase')
//           .withArgs(
//             purchaser.address,
//             purchaser.address,
//             paymentToken,
//             params.sku,
//             quantity,
//             '0x',
//             params.daiPrice,
//             [],
//             [],
//             []
//           )
//           .to.emit(contracts.revv, 'Transfer')
//           .withArgs(contracts.sale.address, purchaser.address, utils.parseEther('1'));
//       });
//     }
//   });
// });
