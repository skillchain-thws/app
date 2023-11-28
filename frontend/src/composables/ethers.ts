import type { JsonRpcSigner, Network } from 'ethers'
import { BrowserProvider } from 'ethers'

export function useEthers() {
  const provider = shallowRef<BrowserProvider>()
  const accounts = shallowRef<string[]>([])
  const network = shallowRef<Network>()
  const signer = shallowRef<JsonRpcSigner>()

  function getProvider() {
    if (!window.ethereum)
      throw new Error('Could not find Metamask extension')
    if (provider.value)
      return provider.value

    provider.value = new BrowserProvider(window.ethereum)
    return provider.value
  }

  async function connect() {
    const p = getProvider()

    const res = await p.send('eth_requestAccounts', [])
    if (res && Array.isArray(res) && res.length)
      accounts.value = res

    network.value = await p.getNetwork()
    signer.value = await p.getSigner()
  }

  onMounted(async () => await connect())

  return { signer, provider }
}
