import { ethers } from 'hardhat'

// eslint-disable-next-line import/order
import { exit } from 'node:process'

async function main() {
  const greeter = await ethers.deployContract('Greeter', ['Initial value'])
  await greeter.waitForDeployment()
  console.log('Greeter deployed to:', greeter.target)
}

main().catch((error) => {
  console.error(error)
  exit(1)
})
