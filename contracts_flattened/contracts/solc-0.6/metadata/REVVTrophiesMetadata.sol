// Sources flattened with hardhat v2.0.3 https://hardhat.org

// File @openzeppelin/contracts/introspection/IERC165.sol@v3.2.0

// SPDX-License-Identifier: MIT

pragma solidity ^0.6.0;

/**
 * @dev Interface of the ERC165 standard, as defined in the
 * https://eips.ethereum.org/EIPS/eip-165[EIP].
 *
 * Implementers can declare support of contract interfaces, which can then be
 * queried by others ({ERC165Checker}).
 *
 * For an implementation, see {ERC165}.
 */
interface IERC165 {
    /**
     * @dev Returns true if this contract implements the interface defined by
     * `interfaceId`. See the corresponding
     * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
     * to learn more about how these ids are created.
     *
     * This function call must use less than 30 000 gas.
     */
    function supportsInterface(bytes4 interfaceId) external view returns (bool);
}


// File @openzeppelin/contracts/introspection/ERC165.sol@v3.2.0

pragma solidity ^0.6.0;

/**
 * @dev Implementation of the {IERC165} interface.
 *
 * Contracts may inherit from this and call {_registerInterface} to declare
 * their support of an interface.
 */
contract ERC165 is IERC165 {
    /*
     * bytes4(keccak256('supportsInterface(bytes4)')) == 0x01ffc9a7
     */
    bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;

    /**
     * @dev Mapping of interface ids to whether or not it's supported.
     */
    mapping(bytes4 => bool) private _supportedInterfaces;

    constructor () internal {
        // Derived contracts need only register support for their own interfaces,
        // we register support for ERC165 itself here
        _registerInterface(_INTERFACE_ID_ERC165);
    }

    /**
     * @dev See {IERC165-supportsInterface}.
     *
     * Time complexity O(1), guaranteed to always use less than 30 000 gas.
     */
    function supportsInterface(bytes4 interfaceId) public view override returns (bool) {
        return _supportedInterfaces[interfaceId];
    }

    /**
     * @dev Registers the contract as an implementer of the interface defined by
     * `interfaceId`. Support of the actual ERC165 interface is automatic and
     * registering its interface id is not required.
     *
     * See {IERC165-supportsInterface}.
     *
     * Requirements:
     *
     * - `interfaceId` cannot be the ERC165 invalid interface (`0xffffffff`).
     */
    function _registerInterface(bytes4 interfaceId) internal virtual {
        require(interfaceId != 0xffffffff, "ERC165: invalid interface id");
        _supportedInterfaces[interfaceId] = true;
    }
}


// File @animoca/ethereum-contracts-core_library/contracts/utils/types/UInt256Extract.sol@v3.1.1

pragma solidity 0.6.8;

library UInt256Extract {

    /**
     * @dev extracts an integer value from certain bits in a uint256
     * @param integer uint256 the base number where to extract the value from.
     * @param length uint256 the number of bits of the value to decode.
     * @param index uint256 the index of the first bit in integer where the value is stored.
     * @return result uint256 the extracted value, shifted to the least significant bits.
     */
    function extract(
        uint256 integer,
        uint256 length,
        uint256 index
    ) internal pure returns (uint256)
    {
        require(length > 0, "UInt256Extract: length is zero");
        require(index + length <= 256, "UInt256Extract: position out of bond");
        uint256 mask = (1 << length) - 1;
        return (integer >> index) & mask;
    }
}


// File @animoca/ethereum-contracts-core_library/contracts/algo/EnumMap.sol@v3.1.1

/*
https://github.com/OpenZeppelin/openzeppelin-contracts

The MIT License (MIT)

Copyright (c) 2016-2019 zOS Global Limited

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
"Software"), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be included
in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/

pragma solidity 0.6.8;

/**
 * @dev Library for managing an enumerable variant of Solidity's
 * https://solidity.readthedocs.io/en/latest/types.html#mapping-types[`mapping`]
 * type.
 *
 * Maps have the following properties:
 *
 * - Entries are added, removed, and checked for existence in constant time
 * (O(1)).
 * - Entries are enumerated in O(n). No guarantees are made on the ordering.
 *
 * ```
 * contract Example {
 *     // Add the library methods
 *     using EnumMap for EnumMap.Map;
 *
 *     // Declare a set state variable
 *     EnumMap.Map private myMap;
 * }
 * ```
 */
library EnumMap {
    // To implement this library for multiple types with as little code
    // repetition as possible, we write it in terms of a generic Map type with
    // bytes32 keys and values.
    // This means that we can only create new EnumMaps for types that fit
    // in bytes32.

    struct MapEntry {
        bytes32 key;
        bytes32 value;
    }

    struct Map {
        // Storage of map keys and values
        MapEntry[] entries;

        // Position of the entry defined by a key in the `entries` array, plus 1
        // because index 0 means a key is not in the map.
        mapping (bytes32 => uint256) indexes;
    }

    /**
     * @dev Adds a key-value pair to a map, or updates the value for an existing
     * key. O(1).
     *
     * Returns true if the key was added to the map, that is if it was not
     * already present.
     */
    function set(Map storage map, bytes32 key, bytes32 value) internal returns (bool) {
        // We read and store the key's index to prevent multiple reads from the same storage slot
        uint256 keyIndex = map.indexes[key];

        if (keyIndex == 0) { // Equivalent to !contains(map, key)
            map.entries.push(MapEntry({ key: key, value: value }));
            // The entry is stored at length-1, but we add 1 to all indexes
            // and use 0 as a sentinel value
            map.indexes[key] = map.entries.length;
            return true;
        } else {
            map.entries[keyIndex - 1].value = value;
            return false;
        }
    }

    /**
     * @dev Removes a key-value pair from a map. O(1).
     *
     * Returns true if the key was removed from the map, that is if it was present.
     */
    function remove(Map storage map, bytes32 key) internal returns (bool) {
        // We read and store the key's index to prevent multiple reads from the same storage slot
        uint256 keyIndex = map.indexes[key];

        if (keyIndex != 0) { // Equivalent to contains(map, key)
            // To delete a key-value pair from the entries array in O(1), we swap the entry to delete with the last one
            // in the array, and then remove the last entry (sometimes called as 'swap and pop').
            // This modifies the order of the array, as noted in {at}.

            uint256 toDeleteIndex = keyIndex - 1;
            uint256 lastIndex = map.entries.length - 1;

            // When the entry to delete is the last one, the swap operation is unnecessary. However, since this occurs
            // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.

            MapEntry storage lastEntry = map.entries[lastIndex];

            // Move the last entry to the index where the entry to delete is
            map.entries[toDeleteIndex] = lastEntry;
            // Update the index for the moved entry
            map.indexes[lastEntry.key] = toDeleteIndex + 1; // All indexes are 1-based

            // Delete the slot where the moved entry was stored
            map.entries.pop();

            // Delete the index for the deleted slot
            delete map.indexes[key];

            return true;
        } else {
            return false;
        }
    }

    /**
     * @dev Returns true if the key is in the map. O(1).
     */
    function contains(Map storage map, bytes32 key) internal view returns (bool) {
        return map.indexes[key] != 0;
    }

    /**
     * @dev Returns the number of key-value pairs in the map. O(1).
     */
    function length(Map storage map) internal view returns (uint256) {
        return map.entries.length;
    }

   /**
    * @dev Returns the key-value pair stored at position `index` in the map. O(1).
    *
    * Note that there are no guarantees on the ordering of entries inside the
    * array, and it may change when more entries are added or removed.
    *
    * Requirements:
    *
    * - `index` must be strictly less than {length}.
    */
    function at(Map storage map, uint256 index) internal view returns (bytes32, bytes32) {
        require(map.entries.length > index, "EnumMap: index out of bounds");

        MapEntry storage entry = map.entries[index];
        return (entry.key, entry.value);
    }

    /**
     * @dev Returns the value associated with `key`.  O(1).
     *
     * Requirements:
     *
     * - `key` must be in the map.
     */
    function get(Map storage map, bytes32 key) internal view returns (bytes32) {
        uint256 keyIndex = map.indexes[key];
        require(keyIndex != 0, "EnumMap: nonexistent key"); // Equivalent to contains(map, key)
        return map.entries[keyIndex - 1].value; // All indexes are 1-based
    }
}


// File @animoca/ethereum-contracts-assets_inventory/contracts/token/ERC721/IERC721Exists.sol@v5.0.0

pragma solidity 0.6.8;

/**
 * @title ERC721 Non-Fungible Token Standard, optional exists extension
 * @dev See https://eips.ethereum.org/EIPS/eip-721
 * Note: The ERC-165 identifier for this interface is 0x4f558e79.
 */
interface IERC721Exists {

    /**
     * @dev Checks the existence of an Non-Fungible Token
     * @return bool true if the token belongs to a non-zero address, false otherwise
     */
    function exists(uint256 nftId) external view returns (bool);
}


// File @animoca/ethereum-contracts-assets_inventory/contracts/token/ERC1155/IERC1155AssetCollections.sol@v5.0.0

pragma solidity 0.6.8;

/**
 * @title ERC-1155 Multi Token Standard, optional Asset Collections extension
 * @dev See https://eips.ethereum.org/EIPS/eip-xxxx
 * Interface for fungible/non-fungible collections management on a 1155-compliant contract.
 * This proposal attempts to rationalize the co-existence of fungible and non-fungible tokens
 * within the same contract. We consider that there 3 types of identifiers:
 * (a) Fungible Collections identifiers, each representing a set of Fungible Tokens,
 * (b) Non-Fungible Collections identifiers, each representing a set of Non-Fungible Tokens,
 * (c) Non-Fungible Tokens identifiers. 


 * In the same way a fungible token (represented by its balance) belongs to a particular id
 * which can be used to store common information about this token, including the metadata.
 *
 * Note: The ERC-165 identifier for this interface is 0x469bd23f.
 */
interface IERC1155AssetCollections {

    /**
     * @dev Returns whether or not an ID represents a Fungible Collection.
     * @param id The ID to query.
     * @return bool true if id represents a Fungible Collection, false otherwise.
     */
    function isFungible(uint256 id) external view returns (bool);

    /**
     * @dev Returns the parent collection ID of a Non-Fungible Token ID.
     * This function returns either a Fungible Collection ID or a Non-Fungible Collection ID.
     * This function SHOULD NOT be used to check the existence of a Non-Fungible Token.
     * This function MAY return a value for a non-existing Non-Fungible Token.
     * @param id The ID to query. id must represent an existing/non-existing Non-Fungible Token, else it throws.
     * @return uint256 the parent collection ID.
     */
    function collectionOf(uint256 id) external view returns (uint256);

    /**
     * @dev Returns the owner of a Non-Fungible Token.
     * @param nftId The identifier to query. MUST represent an existing Non-Fungible Token, else it throws.
     * @return owner address currently marked as the owner of the Non-Fungible Token.
     */
    function ownerOf(uint256 nftId) external view returns (address owner);

    /**
     * @dev Checks the existence of an Non-Fungible Token
     * @return bool true if the token belongs to a non-zero address, false otherwise
     */
    function exists(uint256 nftId) external view returns (bool);
}


// File @animoca/ethereum-contracts-assets_inventory/contracts/metadata/ICoreMetadata.sol@v5.0.0

pragma solidity 0.6.8;

/**
 * @dev Interface for retrieving core metadata attributes encoded in an integer
 * and based on a specific bits layout. A layout consists of a mapping of names
 * to bits position inside a uint256. The position is characterised by a length
 * and an index and must remain in the bounds of 256 bits. Positions of a layout
 * may overlap.
 * Note that these functions are expected to work for any integer provided and
 * should not be expected to have knowledge of the existence of a token in a
 * specific contract.
 */
interface ICoreMetadata {

    /**
     * @dev Retrieve the value of a specific attribute for an integer
     * @param integer uint256 the integer to inspect
     * @param name bytes32 the attribute name to retrieve
     * @return value uint256 the value of the attribute
     */
    function getAttribute(
        uint256 integer,
        bytes32 name
    ) external view returns (uint256 value);

    /**
     * @dev Retrieve the value of a specific attribute for an integer
     * @param integer uint256 the integer to inspect
     * @param names bytes32[] the list of attribute names to retrieve
     * @return values uint256[] the values of the attributes
     */
    function getAttributes(
        uint256 integer,
        bytes32[] calldata names
    ) external view returns (uint256[] memory values);

    /**
     * @dev Retrieve the whole core metadata for an integer
     * @param integer uint256 the integer to inspect
     * @return names bytes32[] the names of the metadata attributes
     * @return values uint256[] the values of the metadata attributes
     */
    function getAllAttributes(uint256 integer) external view returns (
        bytes32[] memory names,
        uint256[] memory values
    );
}


// File @animoca/ethereum-contracts-assets_inventory/contracts/metadata/IInventoryMetadata.sol@v5.0.0

pragma solidity 0.6.8;

/**
 * @dev Interface for retrieving core metadata attributes encoded in an integer
 * and based on a specific bits layout. A layout consists of a mapping of names
 * to bits position inside a uint256. The position is characterised by a length
 * and an index and must remain in the bounds of 256 bits. Positions of a layout
 * may overlap.
 * Note that these functions are expected to work for any integer provided and
 * should not be expected to have knowledge of the existence of a token in a
 * specific contract.
 */
interface IInventoryMetadata {

    /**
     * @dev Get the address of the inventory contracts which delegated
     * core metadata implementation to this contract.
     * MUST return a valid IERC1155AssetCollections implementer address.
     */
    function inventoryMetadataDelegator() external view returns (address);
}


// File @animoca/ethereum-contracts-assets_inventory/contracts/metadata/InventoryMetadata.sol@v5.0.0

pragma solidity 0.6.8;






abstract contract InventoryMetadata is IInventoryMetadata, ICoreMetadata, ERC165 {

    using UInt256Extract for uint256;
    using EnumMap for EnumMap.Map;

    address public override inventoryMetadataDelegator;

    /**
     * A layout is a mapping from a bytes32 name to a uint256 position.
     * A position informs on which bits to extract from an id to retrieve
     * a specific metadata attribute. A uint256 position is composed as follow:
     * - a length which represents the number of bits for the attribute.
     *   (encoded on the 128 least significant bits)
     * - an index which represents the bit position where the attribute begins,
     *   (encoded on the 128 most significant bits)
     *
     * Shorthands:
     * - layout = mapping(name => position)
     * - position = index << 128 | length
     * - attribute_mask = (1 << length) - 1) << index
     * - attribute = id & attribute_mask
     */
    EnumMap.Map internal _defaultFungibleLayout;
    EnumMap.Map internal _defaultNonFungibleLayout;
    mapping(uint256 => EnumMap.Map) internal _layouts;

    constructor(uint256 nfCollectionMaskLength, address delegator) internal {
        _registerInterface(type(ICoreMetadata).interfaceId);
        _registerInterface(type(IInventoryMetadata).interfaceId);

        _setInventoryMetadataDelegator(delegator);

        /*
         * Default Fungible Layout
         *
         *   256                                                                                     0
         *    |--------------------------------------------------------------------------------------|
         *                                     ^ baseCollectionId ^
        */
        _setAttribute(_defaultFungibleLayout, "baseCollectionId", 256, 0);

        /*
         * Default Non-Fungible Layout
         *
         *     < nfCollectionMaskLength >
         *   256                                                                                      0
         *    |-|-------------------------|-----------------------------------------------------------|
         *     F   ^ baseCollectionId ^                        ^ baseTokenId ^
        */
        _setAttribute(
            _defaultNonFungibleLayout,
            "baseTokenId",
            256  - nfCollectionMaskLength,
            0
        );
        _setAttribute(
            _defaultNonFungibleLayout,
            "baseCollectionId",
            nfCollectionMaskLength - 1,
            256 - nfCollectionMaskLength
        );
    }

    function _setInventoryMetadataDelegator(address delegator) internal {
        require(
            IERC165(delegator).supportsInterface(type(IERC1155AssetCollections).interfaceId),
            "InventoryMetadata: delegator does not implement IERC1155AssetCollections"
        );
        inventoryMetadataDelegator = delegator;
    }

    /**
     * @dev Retrieves an attribute which can be either in the default fungible/non-fungible
     * layout or in the relevant collection layout.
     */
    function getAttribute(
        uint256 id,
        bytes32 name
    ) virtual override public view returns (uint256)
    {
        IERC1155AssetCollections delegator = IERC1155AssetCollections(inventoryMetadataDelegator);

        EnumMap.Map storage layout =
            delegator.isFungible(id)?
            _defaultFungibleLayout:
            _defaultNonFungibleLayout;

        if (!layout.contains(name)) {
            layout = _layouts[delegator.collectionOf(id)];
        } 
        uint256 position = uint256(layout.get(name));

        return id.extract(
            uint128(position),
            uint128(position >> 128)
        );
    }

    function getAttributes(
        uint256 id,
        bytes32[] memory names
    ) virtual override public view returns (uint256[] memory values)
    {
        IERC1155AssetCollections delegator = IERC1155AssetCollections(inventoryMetadataDelegator);
        EnumMap.Map storage layout =
            delegator.isFungible(id)?
            _defaultFungibleLayout:
            _defaultNonFungibleLayout;

        values = new uint256[](names.length);

        for (uint256 i = 0; i < names.length; ++i) {
            if (!layout.contains(names[i])) {
                layout = _layouts[delegator.collectionOf(id)];
            }
            uint256 position = uint256(layout.get(names[i]));

            values[i] = id.extract(
                uint128(position),
                uint128(position >> 128)
            );
        }
    }

    /**
     * @dev Retrieves attributes from both the default fungible/non-fungible
     * layout and the relevant collection layout.
     */
    function getAllAttributes(uint256 id) virtual override public view returns (
        bytes32[] memory names,
        uint256[] memory values
    ) {
        IERC1155AssetCollections delegator = IERC1155AssetCollections(inventoryMetadataDelegator);

        EnumMap.Map storage defaultLayout =
            delegator.isFungible(id)?
            _defaultFungibleLayout:
            _defaultNonFungibleLayout;

        EnumMap.Map storage collectionLayout = _layouts[delegator.collectionOf(id)];

        uint256 defaultLayoutLength = defaultLayout.length();
        uint256 collectionLayoutLength = collectionLayout.length();
        uint256 length = defaultLayoutLength + collectionLayoutLength;

        names = new bytes32[](length);
        values = new uint256[](length);

        bytes32 name;
        bytes32 position;
        uint256 index = 0;
        for(uint256 i = 0; i < defaultLayoutLength; i++) {
            (name, position) = defaultLayout.at(i);
            names[index] = name;
            values[index] = id.extract(
                uint128(uint256(position)),
                uint128(uint256(position) >> 128)
            );
            index++;
        }

        for(uint256 i = 0; i < collectionLayoutLength; i++) {
            (name, position) = collectionLayout.at(i);
            names[index] = name;
            values[index] = id.extract(
                uint128(uint256(position)),
                uint128(uint256(position) >> 128)
            );
            index++;
        }
    }

    function _setAttribute(
        EnumMap.Map storage layout,
        bytes32 name,
        uint256 length,
        uint256 index
    ) internal
    {
        // Ensures extraction preconditions are met
        uint256(0).extract(length, index);

        layout.set(name, bytes32(uint256(
            index << 128 |
            length
        )));
    }

    function _getLayout(uint256 collectionId) virtual internal view returns (
        bytes32[] memory names,
        uint256[] memory lengths,
        uint256[] memory indices
    ) {
        EnumMap.Map storage layout = _layouts[collectionId];
        // require(layout.length() > 0, "InventoryMetadata: get non-existent layout");
        uint256 length = layout.length();
        if (length != 0) {
            names = new bytes32[](length);
            lengths = new uint256[](length);
            indices = new uint256[](length);
            for(uint256 i = 0; i < length; i++) {
                bytes32 name; bytes32 pos;
                (name, pos) = layout.at(i);
                uint256 position = uint256(pos);

                names[i] = name;
                lengths[i] = uint128(position);
                indices[i] = uint128(position >> 128);
            }
        }
    }

    function _setLayout(
        uint256 collectionId,
        bytes32[] memory names,
        uint256[] memory lengths,
        uint256[] memory indices
    ) virtual internal
    {
        uint256 size = names.length;
        require(
            (lengths.length == size) && (indices.length == size),
            "InventoryMetadata: set layout with inconsistent array lengths"
        );
        EnumMap.Map storage layout = _layouts[collectionId];
        _clearLayout(layout);

        IERC1155AssetCollections delegator = IERC1155AssetCollections(inventoryMetadataDelegator);
        EnumMap.Map storage defaultLayout =
            delegator.isFungible(collectionId)?
            _defaultFungibleLayout:
            _defaultNonFungibleLayout;

        for (uint256 i = 0; i < size; i++) {
            bytes32 name = names[i];
            require(
                !defaultLayout.contains(name),
                "InventoryMetadata: attribute name already in default layout"
            );
            _setAttribute(layout, name, lengths[i], indices[i]);
        }
    }

    function _clearLayout(EnumMap.Map storage layout) internal {
        uint256 length = layout.length();
        for(uint256 i = 0; i < length; i++) {
            (bytes32 key, ) = layout.at(0);
            layout.remove(key);
        }
    }

    function _clearLayoutByCollectionId(uint256 collectionId) internal {
        EnumMap.Map storage layout = _layouts[collectionId];
        uint256 length = layout.length();
        require(length != 0, "InventoryMetadata: clear a non-existing layout");
        for(uint256 i = 0; i < length; i++) {
            (bytes32 key, ) = layout.at(0);
            layout.remove(key);
        }
    }
}


// File contracts/solc-0.6/metadata/REVVTrophiesMetadata.sol

pragma solidity ^0.6.8;

contract REVVTrophiesMetadata is InventoryMetadata {
    uint256 internal constant NF_MASK_LENGTH = 32;

    modifier onlyDelegator() {
        require(msg.sender == inventoryMetadataDelegator, "Metadata: delegator only");
        _;
    }

    constructor(address delegator) public InventoryMetadata(NF_MASK_LENGTH, delegator) {
        _setAttribute(_defaultNonFungibleLayout, "type", 8, 240);
        _setAttribute(_defaultNonFungibleLayout, "subType", 8, 232);
        _setAttribute(_defaultNonFungibleLayout, "season", 8, 224);
    }

    function setLayout(
        uint256 collectionId,
        bytes32[] memory names,
        uint256[] memory lengths,
        uint256[] memory indices
    ) public onlyDelegator {
        _setLayout(collectionId, names, lengths, indices);
    }
}