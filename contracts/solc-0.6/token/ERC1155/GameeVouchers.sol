// SPDX-License-Identifier: MIT

pragma solidity ^0.6.8;

import "./ERC1155Tradable.sol";

contract GameeVouchers is ERC1155Tradable {
    constructor(address proxyContractAddress) public ERC1155Tradable("GMEE Vouchers", "GMEE_vouch", proxyContractAddress) {}

    /**
     * @notice Mint tokens for each ids in _ids
     * @param _to       The address to mint tokens to
     * @param _ids      Array of ids to mint
     * @param _amounts  Array of amount of tokens to mint per id
     * @param _data    Data to pass if receiver is contract
     */
    function batchMint(
        address _to,
        uint256[] memory _ids,
        uint256[] memory _amounts,
        bytes memory _data
    ) public onlyOwner {
        _batchMint(_to, _ids, _amounts, _data);
    }
}
