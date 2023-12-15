import { ethers } from 'hardhat'
import { exit } from 'node:process'
import { jobs } from '../includes/mocks'

async function main() {
  const signer = (await ethers.getSigners()).at(-1)

  const market = await ethers.deployContract('FreelancerMarketplace', [], { signer })
  await market.waitForDeployment()

  const job = await ethers.deployContract('JobManager', [market.target], { signer })
  const user = await ethers.deployContract('UserManager', [market.target], { signer })
  const escrow = await ethers.deployContract('EscrowManager', [market.target], { signer })

  if (
    market.target !== '0x73511669fd4dE447feD18BB79bAFeAC93aB7F31f'
    || job.target !== '0xB581C9264f59BF0289fA76D61B2D0746dCE3C30D'
    || user.target !== '0xC469e7aE4aD962c30c7111dc580B4adbc7E914DD'
    || escrow.target !== '0x43ca3D2C94be00692D207C6A1e60D8B325c6f12f'
  )
    throw new Error ('Wrong deployed addresses! Restart node and try again')

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

  const isDev = true
  if (isDev) {
    await user.registerUser('admin')
    if ((await user.getAllUserAddresses() as string[])[0] !== signer?.address)
      throw new Error (`Admin address may not correct !`)

    for (const { title, description, price, tags } of jobs)
      await job.addJob(title, description, price, tags)
  }
}

main().catch((error) => {
  console.error(error)
  exit(1)
})
