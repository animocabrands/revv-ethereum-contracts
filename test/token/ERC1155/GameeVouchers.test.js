const {artifacts, web3} = require('hardhat');
const {BN} = web3.utils;
const {ether, expectEvent, expectRevert} = require('@openzeppelin/test-helpers');
const {constants} = require('@animoca/ethereum-contracts-core_library');
const env = require('hardhat');
const {ZeroAddress, EmptyByte, MaxUInt256} = constants;
const {Fungible, NonFungible} = require('@animoca/blockchain-inventory_metadata').inventoryIds;

const nfMaskLength = 32; // constant fixed in the contract implementation

let deployer, payout, owner, operator;

describe('GameeVouchers', function () {
  before(async function () {
    [deployer, payout, owner, operator] = await web3.eth.getAccounts();
  });

  beforeEach(async function () {
    const GameeVouchers = artifacts.require('GameeVouchers');
    this.gameeVouchers = await GameeVouchers.new({from: deployer});
  });

  describe('createCollection', function () {
    it('should revert if not called by the owner', async function () {
      await expectRevert(this.gameeVouchers.createCollection(Fungible.makeCollectionId(1), {from: payout}), 'Ownable: caller is not the owner');
    });

    it('should revert when creating a non-fungible collection', async function () {
      await expectRevert(
        this.gameeVouchers.createCollection(NonFungible.makeCollectionId(1, nfMaskLength), {from: deployer}),
        'GameeVouchers: only fungibles'
      );
    });

    it('should revert if called again for the same id', async function () {
      this.gameeVouchers.createCollection(Fungible.makeCollectionId(1), {from: deployer});
      await expectRevert(this.gameeVouchers.createCollection(Fungible.makeCollectionId(1), {from: deployer}), 'Inventory: existing collection');
    });

    it('should emit a CollectionCreated event and set the creator', async function () {
      const collectionId = Fungible.makeCollectionId(1);
      const receipt = await this.gameeVouchers.createCollection(collectionId, {from: deployer});
      expectEvent(receipt, 'CollectionCreated', {
        collectionId,
        fungible: true,
      });
      expect(await this.gameeVouchers.creator(collectionId)).to.equal(deployer);
    });
  });

  describe('safeBatchMint', function () {
    it('should revert if not called by a minter', async function () {
      await expectRevert(
        this.gameeVouchers.safeBatchMint(owner, [Fungible.makeCollectionId(1)], ['10'], '0x', {from: payout}),
        'MinterRole: caller does not have the Minter role'
      );
    });

    it('should revert if minting to the zero address', async function () {
      await expectRevert(
        this.gameeVouchers.safeBatchMint(ZeroAddress, [Fungible.makeCollectionId(1)], ['10'], '0x', {from: deployer}),
        'Inventory: transfer to zero'
      );
    });

    it('should revert when minting a non-fungible token', async function () {
      await expectRevert(
        this.gameeVouchers.safeBatchMint(owner, [NonFungible.makeTokenId(1, 1, nfMaskLength)], [1], '0x', {
          from: deployer,
        }),
        'GameeVouchers: only fungibles'
      );
    });

    it('should revert if minting more than the total possible supply', async function () {
      this.gameeVouchers.safeBatchMint(owner, [Fungible.makeCollectionId(1)], [MaxUInt256], '0x', {from: deployer});
      await expectRevert(
        this.gameeVouchers.safeBatchMint(owner, [Fungible.makeCollectionId(1)], [1], '0x', {from: deployer}),
        'Inventory: supply overflow'
      );
    });

    it('should emit a TransferBatch event', async function () {
      const ids = [Fungible.makeCollectionId(1)];
      const values = [1];
      const receipt = await this.gameeVouchers.safeBatchMint(owner, ids, values, '0x', {from: deployer});
      expectEvent(receipt, 'TransferBatch', {
        _operator: deployer,
        _from: constants.ZeroAddress,
        _to: owner,
        _ids: ids,
        _values: values,
      });
    });

    it('should fail when minting to a non-receiver contract', async function () {
      const ids = [Fungible.makeCollectionId(1)];
      const values = [1];
      const NonReceiverContract = artifacts.require('REVV');
      const nonReceiverContract = await NonReceiverContract.new([], [], {from: deployer});
      await expectRevert(this.gameeVouchers.safeBatchMint(nonReceiverContract.address, ids, values, '0x', {from: deployer}), 'revert');
    });
  });
});
