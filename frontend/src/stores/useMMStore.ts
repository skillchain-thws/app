import { ToastAction, useToast } from '@/components/ui/toast'
import { EscrowManager__factory, FreelancerMarketplace__factory, JobManager__factory, UserManager__factory } from '@/typechain/factories'
import { MetaMaskConnector, shortenAddress, useWalletStore } from '@vue-dapp/core'
import type { JsonRpcSigner } from 'ethers'
import { BrowserProvider } from 'ethers'
import { acceptHMRUpdate, defineStore } from 'pinia'

export const useMMStore = defineStore('metamask', () => {
  const store = useWalletStore()
  store.onChanged(() => window.location.reload())
  const signer = shallowRef<JsonRpcSigner>()
  const { toast } = useToast()

  const provider = computed(() => window.ethereum ? new BrowserProvider(window.ethereum) : undefined)
  const isConnected = computed(() => store.isConnected)
  const address = computed(() => store.address)
  const shortAddress = computed(() => shortenAddress(store.address))

  async function connect() {
    const connector = new MetaMaskConnector()
    try {
      await store.connectWith(connector)
    }
    catch (e) {
      if (store.error === 'Provider not found')
        window.open('https://metamask.io/download/', '_blank')
    }
  }

  async function getSigner() {
    if (signer.value)
      return signer.value

    if (!provider.value) {
      toast({
        description: 'you must connect with metamask to continue',
        action: h(ToastAction, { altText: 'connect', onClick() {
          connect()
        } }, {
          default: () => 'connect',
        }),

      })
      throw new Error('You must login with Metamask')
    }

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
    getSigner,
    connect,
    getMarketFactory,
    getJobFactory,
    getUserFactory,
    getEscrowFactory,

    isConnected,
    address,
    shortAddress,
  }
})

if (import.meta.hot)
  import.meta.hot.accept(acceptHMRUpdate(useMMStore, import.meta.hot))
