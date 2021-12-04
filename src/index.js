const express = require("express");
const fs = require("fs");
const app = express();


const port = parseInt(process.env.PORT || 3000);
const dataDir = process.env.DATA_DIR || 'public';
const imageURI = process.env.IMAGE_URI || 'ipfs://';
const imageHash = [];

const ipfsClient = require('ipfs-http-client');
const ipfs = ipfsClient.create({ host: 'ipfs.infura.io', port: 5001, protocol: 'https' });
// const ipfs = new ipfsClient()

const result = {};

async function uploadImage() {
  for (let imageId = 1; imageId <= 4; imageId++) {

    const imagePath = `${__dirname}/${dataDir}/images/${imageId}.mp4`
    console.log('imagePath == ', imagePath)
    let imageBuffer;

    if (fs.existsSync(imagePath)) {
      console.log('exist')
      try {
        imageBuffer = fs.readFileSync(imagePath);
      } catch (error) {
        console.error(error);
        return;
      }
      const fileAdded = await ipfs.add(imageBuffer);  
      console.log('fileAdded: ', fileAdded)
      if (!fileAdded) {
        console.error('something went wrong when uploading the file')
        return ;
      }
      result[`image${imageId}`] = fileAdded;
      //create result.json and write hash code following uploading images
      fs.writeFile(`${__dirname}/${dataDir}/result.json`, JSON.stringify(result) , function (err) {
        if (err) throw err;
        console.log('Saved!');
      });
    }
    return;
  }
}
/*
app.get('/api/v0/nfts/:nftId', function(req, res) {
  const nftId = parseInt(req.params.nftId) + 1;
  const jsonPath = `${dataDir}/json/${nftId}.json`;
  try {
      const jsonBuffer = fs.readFileSync(jsonPath);
      const jsonString = jsonBuffer.toString();
      const jsonData = JSON.parse(jsonString);
      jsonData.external_url = `${imageURI}/images/${nftId}.png`;
      jsonData.image = `${imageURI}${imageHash[parseInt(req.params.nftId)]}`;
      return res.json(jsonData);
  } catch (e) {
      console.log(e);
      return res.json({ message: "NFT data not found." }, 404);
  }
});



app.listen(port, () => {
  console.log(`Server running on port ${port}`);
});*/

uploadImage()
