const Universe = artifacts.require('UniVerse');
const baseURI = 'http://54.146.118.202/computer-api/v0/nfts/'; //TODO: update api

module.exports = function(deployer) {
  deployer.deploy(Universe, baseURI).then(() => {
    console.log('UniVerse is deployed.');
  });
};
