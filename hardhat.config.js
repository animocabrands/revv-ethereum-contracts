require('@animoca/ethereum-contracts-core_library/hardhat-plugins');

module.exports = {
  paths: {
    flattened: 'contracts_flattened',
  },
  imports: ['artifacts_imported', 'node_modules/@animoca/ethereum-contracts-assets_inventory/artifacts'],
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
  },
  gasReporter: {
    enabled: process.env.REPORT_GAS ? true : false,
  },
};
