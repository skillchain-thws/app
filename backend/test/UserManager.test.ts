import { expect } from 'chai'
import { ethers } from 'hardhat'
import { deployAll } from '../includes/utils'

async function getAcc0() {
  const { useAccount } = await deployAll()
  const signer = (await ethers.getSigners())[0]
  return await useAccount(signer, 'acc0')
}

describe('userManager', () => {
  it('getUser', async () => {
    const acc0 = await getAcc0()
    expect(await acc0.user.getUser(acc0.address)).to.deep.equal([
      '0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266',
      'acc0',
      true,
      [],
      [],
    ])
  })

  it('getAllUserAddresses', async () => {
    const acc0 = await getAcc0()
    expect(await acc0.user.getAllUserAddresses()).to.deep.equal(['0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266'])
  })

  it('getAllUsers', async () => {
    const acc0 = await getAcc0()
    expect(await acc0.user.getAllUsers()).to.deep.equal([[
      '0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266',
      'acc0',
      true,
      [],
      [],
    ]])
  })

  it('registerUser', async () => {
    const acc0 = await getAcc0()
    await expect(acc0.user.registerUser('')).to.be.revertedWith('String must not be empty')
    await expect(acc0.user.registerUser('acc0')).to.be.revertedWith('Name is already taken')
    await expect(acc0.user.registerUser('acc00')).to.be.revertedWith('User already registered')
  })

  it('functionalities with jobs', async () => {
    const acc0 = await getAcc0()
    await acc0.user.addJobId(1, acc0.address)
    expect(await acc0.user.getAllJobIds(acc0.address)).to.deep.eq([1n])
    await acc0.user.removeJobId(1, acc0.address)
    expect(await acc0.user.getAllJobIds(acc0.address)).to.have.lengthOf(0)
  })

  it('functionalities with escrows', async () => {
    const acc0 = await getAcc0()
    await acc0.user.addEscrowId(1, acc0.address)
    const user = await acc0.user.getUser(acc0.address)
    expect(user[4]).to.deep.equal([1n])
  })

  it('setJudge', async () => {
    const acc0 = await getAcc0()
    await acc0.user.setJudge(acc0.address)
    const user = await acc0.user.getUser(acc0.address)
    expect(user[2]).to.be.true
  })

  it('unsetJudge', async () => {
    const acc0 = await getAcc0()
    await acc0.user.unsetJudge(acc0.address)
    const user = await acc0.user.getUser(acc0.address)
    expect(user[2]).to.be.false
  })
})
