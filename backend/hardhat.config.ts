import '@nomicfoundation/hardhat-toolbox'
import type { HardhatUserConfig } from 'hardhat/config'

const config: HardhatUserConfig = {
  solidity: '0.8.19',
  networks: {
    hardhat: { chainId: 1337 },
  },
  typechain: {
    outDir: '../frontend/src/typechain',
  },
}

export default config
