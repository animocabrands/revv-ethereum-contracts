// SPDX-License-Identifier: MIT

pragma solidity 0.6.8;

// import "@animoca/ethereum-contracts-erc20_base/contracts/mocks/token/ERC20/ERC20Mock.sol";
import "@animoca/ethereum-contracts-erc20_base/contracts/token/ERC20/ERC20WithOperators.sol";

contract ERC20MintableMock is ERC20, Ownable {
    // solhint-disable-next-line const-name-snakecase
    string public override constant name = "ERC20";
    // solhint-disable-next-line const-name-snakecase
    string public override constant symbol = "E20";
    // solhint-disable-next-line const-name-snakecase
    uint8 public override constant decimals = 18;

    constructor(address[] memory tos, uint256[] memory amounts) public {
        batchMint(tos, amounts);
    }

    function batchMint(address[] memory tos, uint256[] memory amounts) public onlyOwner {
        uint256 length = tos.length;
        require(length == amounts.length, "ERC20: inconsistent arrays");
        for (uint256 i = 0; i < length; ++i) {
            _mint(tos[i], amounts[i]);
        }
    }
}

contract ERC20WithOperatorsMintableMock is ERC20WithOperators {
    // solhint-disable-next-line const-name-snakecase
    string public override constant name = "ERC20";
    // solhint-disable-next-line const-name-snakecase
    string public override constant symbol = "ERC20";
    // solhint-disable-next-line const-name-snakecase
    uint8 public override constant decimals = 18;

    constructor(address[] memory tos, uint256[] memory amounts) public {
        batchMint(tos, amounts);
    }

    function batchMint(address[] memory tos, uint256[] memory amounts) public onlyOwner {
        uint256 length = tos.length;
        require(length == amounts.length, "ERC20: inconsistent arrays");
        for (uint256 i = 0; i < length; ++i) {
            _mint(tos[i], amounts[i]);
        }
    }
}
