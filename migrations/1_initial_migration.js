const Universe = artifacts.require('UniVerse');
const baseURI = 'https://ras-nft.herokuapp.com/api/v0/nfts/'; //TODO: update api

module.exports = function(deployer) {
  deployer.deploy(Universe, baseURI).then(() => {
    console.log('UniVerse is deployed.');
  });
};
