require('./plugins/hardhat-flatten-all');
require('./plugins/hardhat-solidity-docgen');
require('./plugins/hardhat-import-artifacts');
require('./plugins/hardhat-solidity-coverage');
require('@nomiclabs/hardhat-truffle5');
require('hardhat-gas-reporter');

module.exports = {
  paths: {
    flattened: 'contracts_flattened',
  },
  imports: ['artifacts_imported'],
  solidity: {
    docgen: {
      input: 'contracts/solc-0.6',
      templates: 'docs-template',
    },
    compilers: [
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
  gasReporter: {
    enabled: process.env.REPORT_GAS ? true : false,
  },
};
