const express = require("express");
const fs = require("fs");
const app = express();


const port = parseInt(process.env.PORT || 3000);
const dataDir = process.env.DATA_DIR || 'public';
const imageURI = process.env.IMAGE_URI || 'https://ipfs.io/ipfs';
const imageHash = [];

app.get('/api/v0/nfts/:nftId', function(req, res) {
  const nftId = parseInt(req.params.nftId) + 1;
  const jsonPath = `${dataDir}/json/${nftId}.json`;
  try {
      const jsonBuffer = fs.readFileSync(jsonPath);
      const jsonString = jsonBuffer.toString();
      const jsonData = JSON.parse(jsonString);
      jsonData.external_url = `${imageURI}/images/${nftId}.png`;
      jsonData.image = `${imageURI}/${imageHash[parseInt(req.params.nftId)]}`;
      return res.json(jsonData);
  } catch (e) {
      console.log(e);
      return res.json({ message: "NFT data not found." }, 404);
  }
});



app.listen(port, () => {
  console.log(`Server running on port ${port}`);
});

// uploadImage()
