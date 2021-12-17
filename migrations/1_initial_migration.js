const Universe = artifacts.require('UniVerse');
const UniverseToken = artifacts.require('Token');
const baseURI = 'https://ras-nft.herokuapp.com/api/v0/nfts/'; //TODO: update api

// module.exports = function (deployer) {
//   deployer.deploy(UniverseToken).then(() => {
//     console.log('UniVerseToken is deployed.');
//   });

//   deployer.deploy(Universe, baseURI, UniverseToken.address).then(() => {
//     console.log('UniVerse is deployed.');
//   });
// };

module.exports = async function (deployer) {
  // deployer.deploy(UniverseToken).then(() => {
  //   console.log('UniVerseToken is deployed.');
  // });
  deployer.deploy(Universe, baseURI, "0x23FDF1253C7f7e387930C9B3276C1578545ccf46").then(() => {
    console.log('UniVerse is deployed.');
  });
};
