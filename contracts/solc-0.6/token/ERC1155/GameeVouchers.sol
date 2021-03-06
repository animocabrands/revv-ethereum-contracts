// SPDX-License-Identifier: MIT

pragma solidity ^0.6.8;

import "@animoca/ethereum-contracts-assets_inventory-6/contracts/token/ERC1155/ERC1155Inventory.sol";
import "@animoca/ethereum-contracts-assets_inventory-6/contracts/token/ERC1155/IERC1155InventoryMintable.sol";
import "@animoca/ethereum-contracts-assets_inventory-6/contracts/token/ERC1155/IERC1155InventoryBurnable.sol";
import "@animoca/ethereum-contracts-assets_inventory-6/contracts/token/ERC1155/IERC1155InventoryCreator.sol";
import "@animoca/ethereum-contracts-assets_inventory-6/contracts/metadata/BaseMetadataURI.sol";
import "@animoca/ethereum-contracts-core_library-3/contracts/access/MinterRole.sol";

contract GameeVouchers is
    ERC1155Inventory,
    IERC1155InventoryMintable,
    IERC1155InventoryBurnable,
    IERC1155InventoryCreator,
    BaseMetadataURI,
    MinterRole
{
    // solhint-disable-next-line const-name-snakecase
    string public constant name = "GameeVouchers";
    // solhint-disable-next-line const-name-snakecase
    string public constant symbol = "GameeVouchers";

    // ===================================================================================================
    //                               Admin Public Functions
    // ===================================================================================================

    /**
     * Creates a collection.
     * @dev Reverts if `collectionId` does not represent a collection.
     * @dev Reverts if `collectionId` has already been created.
     * @dev Emits a {IERC1155Inventory-CollectionCreated} event.
     * @param collectionId Identifier of the collection.
     */
    function createCollection(uint256 collectionId) external onlyOwner {
        require(isFungible(collectionId), "GameeVouchers: only fungibles");
        _createCollection(collectionId);
    }

    /**
     * @dev See {IERC1155InventoryMintable-safeMint(address,uint256,uint256,bytes)}.
     */
    function safeMint(
        address to,
        uint256 id,
        uint256 value,
        bytes calldata data
    ) external override onlyMinter {
        require(isFungible(id), "GameeVouchers: only fungibles");
        _safeMint(to, id, value, data);
    }

    /**
     * @dev See {IERC1155721InventoryMintable-safeBatchMint(address,uint256[],uint256[],bytes)}.
     */
    function safeBatchMint(
        address to,
        uint256[] calldata ids,
        uint256[] calldata values,
        bytes calldata data
    ) external override onlyMinter {
        _safeBatchMint(to, ids, values, data);
        for (uint256 i; i != ids.length; ++i) {
            require(isFungible(ids[i]), "GameeVouchers: only fungibles");
        }
    }

    // ===================================================================================================
    //                                 User Public Functions
    // ===================================================================================================

    /**
     * @dev See {IERC1155InventoryCreator-creator(uint256)}.
     */
    function creator(uint256 collectionId) external view override returns (address) {
        require(!isNFT(collectionId), "Inventory: not a collection");
        return _creators[collectionId];
    }

    /**
     * @dev See {IERC1155InventoryBurnable-burnFrom(address,uint256,uint256)}.
     */
    function burnFrom(
        address from,
        uint256 id,
        uint256 value
    ) external override {
        _burnFrom(from, id, value);
    }

    /**
     * @dev See {IERC1155InventoryBurnable-batchBurnFrom(address,uint256[],uint256[])}.
     */
    function batchBurnFrom(
        address from,
        uint256[] calldata ids,
        uint256[] calldata values
    ) external override {
        _batchBurnFrom(from, ids, values);
    }

    // ===================================================================================================
    //                                  ERC1155 Internal Functions
    // ===================================================================================================

    function _uri(uint256 id) internal view override(ERC1155InventoryBase, BaseMetadataURI) returns (string memory) {
        return BaseMetadataURI._uri(id);
    }
}
