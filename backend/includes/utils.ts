import type { HardhatEthersSigner } from '@nomicfoundation/hardhat-ethers/signers'
import { ethers } from 'hardhat'

type Contract = Awaited<ReturnType<typeof ethers.deployContract>>

export async function deployAll() {
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

  const useAccount = async (s: HardhatEthersSigner, username: string) => {
    const _chat = chat.connect(s) as Contract
    const _committee = committee.connect(s) as Contract
    const _escrow = escrow.connect(s) as Contract
    const _job = job.connect(s) as Contract
    const _review = review.connect(s) as Contract
    const _user = user.connect(s) as Contract

    await _user.registerUser(username)

    return {
      chat: _chat,
      committee: _committee,
      escrow: _escrow,
      job: _job,
      review: _review,
      user: _user,
      address: s.address,
    }
  }

  return { market, chat, committee, escrow, job, review, user, useAccount, admin }
}
