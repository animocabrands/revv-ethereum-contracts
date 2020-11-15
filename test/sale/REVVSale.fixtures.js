const {waffle, ethers} = require('hardhat');
const {constants, utils, BigNumber, getContractFactory} = ethers;
const {deployContract, link, createFixtureLoader, provider} = waffle;

const {EthAddress} = require('../../src/constants');

const sku = utils.formatBytes32String('flash REVV');
const daiPrice = BigNumber.from('6660000000000000');
const ethPrice = BigNumber.from('16650000000000');

async function initContracts([deployer, purchaser, payout]) {
  const REVV = await getContractFactory('REVV');
  const dai = await REVV.deploy([purchaser.address], [utils.parseEther('100000000')]);
  await dai.deployed();

  const totalSupply = '7500000'; // 7.5M
  const revv = await REVV.deploy([deployer.address], [utils.parseEther(totalSupply)]);
  await revv.deployed();

  const bytesArtifact = require('../../imports/Bytes.json');
  const bytes = await deployContract(deployer, bytesArtifact, []);

  const inventoryArtifact = require('../../imports/DeltaTimeInventory.json');
  inventoryArtifact.evm = {bytecode: {object: inventoryArtifact.bytecode}};
  link(inventoryArtifact, 'Bytes', bytes.address);
  const inventory = await deployContract(deployer, inventoryArtifact, [revv.address, payout.address]);

  const Sale = await getContractFactory('REVVSale');
  const sale = await Sale.deploy(revv.address, inventory.address, payout.address);

  await revv.approve(sale.address, utils.parseEther(totalSupply));

  const maxPurchaseAmount = '700000'; // 700k
  await sale.createSku(sku, totalSupply, maxPurchaseAmount, constants.AddressZero);

  const prices = {}; // in wei
  prices[dai.address] = daiPrice;
  prices[EthAddress] = ethPrice;
  await sale.updateSkuPricing(sku, Object.keys(prices), Object.values(prices));

  await sale.start();

  return {
    contracts: {
      dai,
      revv,
      inventory,
      sale,
    },
    params: {
      sku,
      ethPrice,
      daiPrice,
    },
  };
}

async function initContractsAndMintNft([deployer, purchaser, payout], provider) {
  // TODO: this does not retrieve the existing fixture but creates a new one, to fix when waffle.loadFixture is fixed:
  // https://github.com/nomiclabs/hardhat/issues/849
  const loadFixture = createFixtureLoader([deployer, purchaser, payout], provider);
  const {contracts, params} = await loadFixture(initContracts);

  await contracts.inventory.batchMint(
    [purchaser.address],
    ['0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF'], // an NFT
    [constants.HashZero],
    [1],
    true
  );
  return {
    contracts,
    params,
  };
}

module.exports = {
  initContracts,
  initContractsAndMintNft,
};
