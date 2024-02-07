import { expect } from 'chai'
import { ethers } from 'hardhat'

describe('freelancerMarketplace', () => {
  it('deploy market', async () => {
    const signers = await ethers.getSigners()
    const admin = signers[signers.length - 1]

    const market = await ethers.deployContract('FreelancerMarketplace', [], { signer: admin })
    await market.waitForDeployment()

    expect(await market.isAdmin(signers[0].address)).to.be.false
    expect(await market.isAdmin(admin.address)).to.be.true
  })
})
