const Universe = artifacts.require('UniVerse');
const UniverseToken = artifacts.require('Token');
const baseURI = 'https://ras-nft.herokuapp.com/api/v0/nfts/'; //TODO: update api

module.exports = function(deployer) {
  deployer.deploy(UniverseToken).then(() => {
    console.log('UniVerseToken is deployed.');
  });

  deployer.deploy(Universe, baseURI, UniverseToken.address).then(() => {
    console.log('UniVerse is deployed.');
  });
};
