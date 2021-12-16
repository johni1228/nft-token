var HDWalletProvider = require("@truffle/hdwallet-provider");
const dotenv = require('dotenv');
dotenv.config();
const MNEMONIC = process.env.MNEMONIC;

module.exports = {

  networks: {
    development: {
      host: "127.0.0.1",     // Localhost (default: none)
      port: 8545,            // Standard Ethereum port (default: none)
      network_id: "*",       // Any network (default: none)
    },

    bsctest: {
      provider: () => new HDWalletProvider(MNEMONIC, `https://data-seed-prebsc-1-s1.binance.org:8545/`),
      network_id: 97 ,       // Rinkeby's id
      confirmations: 2,    // # of confs to wait between deployments. (default: 0)
      timeoutBlocks: 200,  // # of blocks before a deployment times out  (minimum/default: 50)
      skipDryRun: true     // Skip dry run before migrations? (default: false for public nets )
    },

    kovanTestNet: {
      provider: () => new HDWalletProvider(MNEMONIC, `https://kovan.infura.io/v3/9aa3d95b3bc440fa88ea12eaa4456161`),
      network_id: 42,
      networkCheckTimeout: 120000,
      confirmations: 3,
      timeoutBlocks: 200,
      skipDryRun: true
    },

    mainNet: {
      provider: () => new HDWalletProvider(MNEMONIC, `https://mainnet.infura.io/v3/9aa3d95b3bc440fa88ea12eaa4456161`),
      network_id: 1,
      networkCheckTimeout: 120000,
      confirmations: 5,
      timeoutBlocks: 200,
      skipDryRun: true
    },
  },
  // Set default mocha options here, use special reporters etc.
  mocha: {
    // timeout: 100000
  },
  // Configure your compilers
  compilers: {
    solc: {
      version: "0.8.0",    // Fetch exact version from solc-bin (default: truffle's version)
      docker: false,        // Use "0.5.1" you've installed locally with docker (default: false)
      settings: {          // See the solidity docs for advice about optimization and evmVersion
        optimizer: {
          enabled: true,
          runs: 999
        }
      }
    }
  },

  db: {
    enabled: false
  },
  plugins: [
    'truffle-plugin-verify'
  ],
  api_keys: {
    etherscan: 'R93VASIPJPBCAS9Z27DSUDWX518SEY9QPK',
    bscscan: 'A2HNWK3VKZNQFAGU254HW1DAG4RPB8FI8T'
  }
};
