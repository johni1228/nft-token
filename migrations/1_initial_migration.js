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
  const token = await deployer.deploy(UniverseToken).then(() => {
    console.log('UniVerseToken is deployed.', UniverseToken.address);
  });
  console.log(token.address)
  deployer.deploy(Universe, baseURI, "0x3F8c2A5dAC285f56555bac2E91d47D51c356B417").then(() => {
    console.log('UniVerse is deployed.');
  });
};
