import { ToastAction, useToast } from '@/components/ui/toast'
import { EscrowManager__factory, FreelancerMarketplace__factory, JobManager__factory, UserManager__factory } from '@/typechain/factories'
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
export const useMMStore = defineStore('metamask', () => {
  const signer = shallowRef<JsonRpcSigner>()
  const { toast } = useToast()

  const provider = shallowRef(new BrowserProvider(window.ethereum))
  const address = ref('')
  const isConnected = computed(() => address.value)
  const shortAddress = computed(() => {
    const length = address.value.length
    return `${address.value.substring(2, 7)}...${address.value.substring(length - 5, length)}`
  })
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
    try {
      const accounts = await window?.ethereum?.request({ method: 'eth_requestAccounts' }) as string[]
      address.value = accounts[0]
    }
    catch (e) {
      window.open('https://metamask.io/download/', '_blank')
    }
  }

  async function getSigner() {
    if (signer.value)
      return signer.value

    if (!provider.value) {
      toast({
        description: 'you must connect with metamask to continue',
        action: h(ToastAction, {
          altText: 'connect',
          onClick() {
            connect()
          },
        }, {
          default: () => 'connect',
        }),

      })
      throw new Error('You must login with Metamask')
    }

    signer.value = await provider.value.getSigner()
    return signer.value
  }

  async function getBalance() {
    try {
      return Number(await provider.value.getBalance(address.value))
    }
    catch {
      return 0
    }
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
    getBalance,
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
  }
})
