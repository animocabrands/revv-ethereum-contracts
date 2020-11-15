// require('solidity-coverage');
require('@nomiclabs/hardhat-solhint');
require('@nomiclabs/hardhat-ethers'); // imported by @nomiclabs/hardhat-waffle
require('@nomiclabs/hardhat-waffle');
// require('hardhat-deploy');
// require('hardhat-deploy-ethers');

module.exports = {
  solidity: {
    compilers: [
      {
        version: '0.5.16',
        settings: {
          optimizer: {
            enabled: true,
            runs: 200,
          },
        },
      },
      {
        version: '0.6.8',
        settings: {
          optimizer: {
            enabled: true,
            runs: 2000,
          },
        },
      },
    ],
    overrides: {
      'contracts/solc-0.6/token/ERC1155721/REVVTrophies.sol': {
        version: '0.6.8',
        settings: {
          optimizer: {
            enabled: true,
            // lower value to reduce the size of the produced code
            runs: 200,
          },
        },
      },
    },
  },
};
