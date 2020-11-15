const {waffle} = require('hardhat');

// This is a workaround as described in https://github.com/nomiclabs/hardhat/issues/849
function loadFixture(signers) {
  return waffle.createFixtureLoader(signers.values());
}

module.exports = {
  loadFixture,
};
