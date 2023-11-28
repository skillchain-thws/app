import { BrowserProvider } from 'ethers'

export function useEthers() {
  if (!window.ethereum)
    throw new Error ('No Metamask installed!')

  const ethereum = shallowRef(window.ethereum)
  const provider = shallowRef(new BrowserProvider(ethereum.value))

  async function requestAccount() {
    await ethereum.value.request({ method: 'eth_requestAccounts' })
  }

  return { provider, ethereum, requestAccount }
}
