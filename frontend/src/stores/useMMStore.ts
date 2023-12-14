import { useToast } from '@/components/ui/toast'
import { MetaMaskConnector, shortenAddress, useWalletStore } from '@vue-dapp/core'
import type { JsonRpcSigner } from 'ethers'
import { BrowserProvider } from 'ethers'
import { acceptHMRUpdate, defineStore } from 'pinia'

import { EscrowManager__factory, FreelancerMarketplace__factory, JobManager__factory, UserManager__factory } from '@/typechain/factories'

// @ts-expect-error no types
import jazzicon from '@metamask/jazzicon'

export const useMMStore = defineStore('metamask', () => {
  // ref
  const store = useWalletStore()
  const signer = shallowRef<JsonRpcSigner>()

  // computed
  const provider = computed(() => window.ethereum ? new BrowserProvider(window.ethereum) : undefined)
  const isConnected = computed(() => store.isConnected)
  const address = computed(() => store.address)
  const shortAddress = computed(() => shortenAddress(store.address))

  const { toast } = useToast()

  async function connect() {
    const connector = new MetaMaskConnector()
    await store.connectWith(connector)
    const addr = store.address.slice(2, 10)
    const seed = Number.parseInt(addr, 16)
    const icon = jazzicon(35, seed)
    return { icon }
  }

  async function getSigner() {
    if (signer.value)
      return signer.value

    if (!provider.value) {
      toast({ description: 'You must login with Metamask', variant: 'destructive' })
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
