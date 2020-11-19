// SPDX-License-Identifier: MIT

pragma solidity ^0.6.8;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@animoca/ethereum-contracts-core_library/contracts/access/MinterRole.sol";
import "@animoca/ethereum-contracts-core_library/contracts/utils/types/UInt256ToDecimalString.sol";
import "@animoca/ethereum-contracts-assets_inventory/contracts/token/ERC1155/ERC1155Inventory.sol";

contract GameeVouchers is ERC1155Inventory, Ownable, MinterRole {
    using UInt256ToDecimalString for uint256;

    string public name = "GameeVouchers";
    string public symbol = "GameeVouchers";

    string internal _baseMetadataURI;

    constructor(address proxyContractAddress) public ERC1155Inventory() {}

    function createCollection(uint256 collectionId) external onlyOwner {
        _createCollection(collectionId);
    }

    function setBaseMetadataURI(string calldata baseMetadataURI) external onlyOwner {
        _baseMetadataURI = baseMetadataURI;
    }

    function batchMint(
        address to,
        uint256[] memory ids,
        uint256[] memory values,
        bytes memory data
    ) public onlyMinter {
        _batchMint(to, ids, values, data, false);
    }

    function safeBatchMint(
        address to,
        uint256[] memory ids,
        uint256[] memory values,
        bytes memory data
    ) public onlyMinter {
        _batchMint(to, ids, values, data, true);
    }

    function sameNFTCollectionBatchMint(address to, uint256[] memory ids) public onlyMinter {
        _sameNFTCollectionBatchMint(to, ids, "", false);
    }

    function sameNFTCollectionSafeBatchMint(
        address to,
        uint256[] memory ids,
        bytes memory data
    ) public onlyMinter {
        _sameNFTCollectionBatchMint(to, ids, data, true);
    }

    function burnFrom(
        address from,
        uint256 id,
        uint256 value
    ) external {
        bool batch = false;
        _burnFrom(from, id, value, batch);
    }

    function batchBurnFrom(
        address from,
        uint256[] calldata ids,
        uint256[] calldata values
    ) external {
        _batchBurnFrom(from, ids, values);
    }

    function sameNFTCollectionBatchBurnFrom(address from, uint256[] calldata nftIds) external {
        _sameNFTCollectionBatchBurnFrom(from, nftIds);
    }

    function _uri(uint256 id) internal override view returns (string memory) {
        return string(abi.encodePacked("https://prefix/json/", id.toDecimalString()));
    }
}
