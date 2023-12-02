import { useToast } from '@/components/ui/toast'
import { MetaMaskConnector, shortenAddress, useWalletStore } from '@vue-dapp/core'
import type { JsonRpcSigner } from 'ethers'
import { BrowserProvider } from 'ethers'
import { acceptHMRUpdate, defineStore } from 'pinia'

// @ts-expect-error no types
import jazzicon from '@metamask/jazzicon'

export const useMMStore = defineStore('metamask', () => {
  // ref
  const store = useWalletStore()
  const signer = shallowRef<JsonRpcSigner>()

  // computed
  const provider = computed(() => store.provider ? new BrowserProvider(store.provider) : undefined)
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

  return { getSigner, connect, isConnected, address, shortAddress }
})

if (import.meta.hot)
  import.meta.hot.accept(acceptHMRUpdate(useMMStore, import.meta.hot))
