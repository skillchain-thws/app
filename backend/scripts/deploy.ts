import { ethers } from 'hardhat'
import { exit } from 'node:process'
import { jobs } from '../includes/mocks'

async function main() {
  const market = await ethers.deployContract('FreelancerMarketplace')
  await market.waitForDeployment()

  const job = await ethers.deployContract('JobManager', [market.target])
  const user = await ethers.deployContract('UserManager', [market.target])
  const escrow = await ethers.deployContract('EscrowManager', [market.target])

  console.log('FreelancerMarketplace deployed to:', market.target)
  console.log('JobManager deployed to:', job.target)
  console.log('UserManager deployed to:', user.target)
  console.log('EscrowManager deployed to:', escrow.target)

  await Promise.all([
    job.waitForDeployment(),
    user.waitForDeployment(),
    escrow.waitForDeployment(),
  ])

  await Promise.all([
    await job.setUserManager(user.target),
    await job.setEscrowManager(escrow.target),
    await escrow.setUserManager(user.target),
    await escrow.setJobManager(job.target),
  ])

  // Only in dev
  if (true) {
    await user.registerUser('Admin')
    for (const j of jobs)
      await job.addJob(j.title, j.description, j.price, j.tags)
  }
}

main().catch((error) => {
  console.error(error)
  exit(1)
})
