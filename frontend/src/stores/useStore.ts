import { EscrowManager__factory, FreelancerMarketplace__factory, JobManager__factory, UserManager__factory } from '@/typechain/factories'
import { shortenAddr } from '@/utils'
import type { JsonRpcSigner } from 'ethers'
import { BrowserProvider } from 'ethers'
import { defineStore } from 'pinia'

interface User {
  owner: string
  userName: string
  isJudge: boolean
  jobIds: number[]
  reviewsBuyerCount: number
  reviewSellerCount: number
}
export const useStore = defineStore('metamask', () => {
  const signer = shallowRef<JsonRpcSigner>()
  const provider = shallowRef(new BrowserProvider(window.ethereum))
  const address = ref('')
  const isConnected = computed(() => !!address.value)
  const shortAddress = computed(() => shortenAddr(address.value))
  const balance = ref('0')
  const user = shallowRef<User>({
    owner: '0x0000000000000000000000000000000000000000',
    userName: '',
    isJudge: false,
    jobIds: [],
    reviewsBuyerCount: 0,
    reviewSellerCount: 0,
  })
  const isRegisterd = computed(() => !!user.value.userName)

  async function fetchUser() {
    const factory = await getUserFactory()
    const u = await factory.getUser(address.value)
    user.value = {
      owner: u[0],
      userName: u[1],
      isJudge: u[2],
      jobIds: u[3].map(Number),
      reviewsBuyerCount: Number(u[4]),
      reviewSellerCount: Number(u[5]),
    }
  }

  async function connect() {
    const accounts = await window.ethereum.request({ method: 'eth_requestAccounts' }) as string[]
    address.value = accounts[0]
    const _balance = Number(await provider.value.getBalance(address.value))
    balance.value = (_balance / 1e18).toFixed(4)
  }

  async function getSigner() {
    if (signer.value)
      return signer.value

    signer.value = await provider.value.getSigner()
    return signer.value
  }

  async function getMarketFactory() {
    const address = import.meta.env.VITE_MARKET_ADDRESS
    return FreelancerMarketplace__factory.connect(address, await getSigner())
  }

  async function getJobFactory() {
    const address = import.meta.env.VITE_JOB_ADDRESS
    return JobManager__factory.connect(address, await getSigner())
  }

  async function getUserFactory() {
    const address = import.meta.env.VITE_USER_ADDRESS
    return UserManager__factory.connect(address, await getSigner())
  }

  async function getEscrowFactory() {
    const address = import.meta.env.VITE_ESCROW_ADDRESS
    return EscrowManager__factory.connect(address, await getSigner())
  }

  return {
    connect,
    getSigner,
    getMarketFactory,
    getJobFactory,
    getUserFactory,
    getEscrowFactory,
    fetchUser,

    isConnected,
    address,
    shortAddress,
    isRegisterd,
    user,
    balance,
  }
})
