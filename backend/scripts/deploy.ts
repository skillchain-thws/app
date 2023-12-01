import { ethers } from 'hardhat'
import { exit } from 'node:process'

async function main() {
  const contract = await ethers.deployContract('FreelancerMarketplace')
  await contract.waitForDeployment()
  console.log('FreelancerMarketplace deployed to:', contract.target)
}

main().catch((error) => {
  console.error(error)
  exit(1)
})
