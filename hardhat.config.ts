import '@typechain/hardhat'
import '@nomiclabs/hardhat-ethers'
import '@nomiclabs/hardhat-waffle'

/**
 * @type import('hardhat/config').HardhatUserConfig
 */
export default {
  typechain: {
    outDir: "src/types",
    target: "ethers-v5",
  },
  solidity: "0.7.0"
};
