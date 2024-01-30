import type { HardhatEthersSigner } from '@nomicfoundation/hardhat-ethers/signers'
import { ethers } from 'hardhat'
import { exit } from 'node:process'
import { jobs } from '../includes/mocks'

type Contract = Awaited<ReturnType<typeof ethers.deployContract>>

async function main() {
  const signers = await ethers.getSigners()
  const admin = signers[signers.length - 1]

  const market = await ethers.deployContract('FreelancerMarketplace', [], { signer: admin })
  await market.waitForDeployment()

  const chat = await ethers.deployContract('ChatManager', [market.target], { signer: admin })
  const committee = await ethers.deployContract('CommitteeManager', [market.target], { signer: admin })
  const escrow = await ethers.deployContract('EscrowManager', [market.target], { signer: admin })
  const job = await ethers.deployContract('JobManager', [market.target], { signer: admin })
  const review = await ethers.deployContract('ReviewManager', [market.target], { signer: admin })
  const user = await ethers.deployContract('UserManager', [market.target], { signer: admin })

  if (
    market.target !== '0x73511669fd4dE447feD18BB79bAFeAC93aB7F31f'
    || chat.target !== '0xB581C9264f59BF0289fA76D61B2D0746dCE3C30D'
    || committee.target !== '0xC469e7aE4aD962c30c7111dc580B4adbc7E914DD'
    || escrow.target !== '0x43ca3D2C94be00692D207C6A1e60D8B325c6f12f'
    || job.target !== '0xb09da8a5B236fE0295A345035287e80bb0008290'
    || review.target !== '0x5095d3313C76E8d29163e40a0223A5816a8037D8'
    || user.target !== '0x391342f5acAcaaC9DE1dC4eC3E03f2678f7c78F1'
  )
    throw new Error ('Wrong deployed addresses! Restart node and try again')

  await Promise.all([
    chat.waitForDeployment(),
    committee.waitForDeployment(),
    escrow.waitForDeployment(),
    job.waitForDeployment(),
    review.waitForDeployment(),
    user.waitForDeployment(),
  ])

  await Promise.all([
    chat.setJobManager(job.target),
    chat.setEscrowManager(escrow.target),
    chat.setUserManager(user.target),

    committee.setUserManager(user.target),
    committee.setEscrowManager(escrow.target),

    escrow.setJobManager(job.target),
    escrow.setUserManager(user.target),
    escrow.setCommitteeManager(committee.target),
    escrow.setChatManager(chat.target),

    job.setEscrowManager(escrow.target),
    job.setUserManager(user.target),

    review.setEscrowManager(escrow.target),
    review.setJobManager(job.target),
    review.setUserManager(user.target),

    user.setCommitteeManager(committee.target),
  ])

  const isDev = true
  if (isDev) {
    const useAccount = async (s: HardhatEthersSigner, username: string) => {
      const _user = user.connect(s) as Contract
      const _job = job.connect(s) as Contract
      const _escrow = escrow.connect(s) as Contract

      await _user.registerUser(username)

      return { user: _user, job: _job, escrow: _escrow }
    }

    await user.registerUser('admin')
    const account0 = await useAccount(signers[0], 'acc0')
    const account1 = await useAccount(signers[1], 'acc1')
    for (let i = 2; i <= 18; i++)
      await useAccount(signers[i], `acc${i}`)

    for (const { title, description, price, tags } of jobs.slice(0, 5))
      await account0.job.addJob(title, description, price, tags)

    for (const { title, description, price, tags } of jobs.slice(5, 10))
      await account1.job.addJob(title, description, price, tags)

    await account1.job.sendBuyRequest(0, 'message')
    await account0.job.acceptBuyRequest(0, 0)

    await account1.job.sendBuyRequest(1, 'message')
    await account0.job.acceptBuyRequest(1, 0)

    await account0.job.sendBuyRequest(5, 'message')
    await account1.job.acceptBuyRequest(5, 0)

    await account0.job.sendBuyRequest(6, 'message')
    await account1.job.acceptBuyRequest(6, 0)
  }
}

main().catch((error) => {
  console.error(error)
  exit(1)
})
