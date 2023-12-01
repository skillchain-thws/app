<script setup lang="ts">
import { FreelancerMarketplace__factory } from '@/typechain/factories/FreelancerMarketplace__factory'
import { useWalletStore } from '@vue-dapp/core'
import { BrowserProvider } from 'ethers'

const store = useWalletStore()
const DEPLOYED_ADDRESS = import.meta.env.VITE_DEPLOYED_ADDRESS

onMounted(async () => {
  if (!store.provider)
    return
  const provider = new BrowserProvider(store.provider)
  const signer = await provider.getSigner()
  const factory = FreelancerMarketplace__factory.connect(DEPLOYED_ADDRESS, signer)

  console.log(await factory.users('0xdD2FD4581271e230360230F9337D5c0430Bf44C0'))
  console.log(await factory.userCount())
  // factory.addJob('some title', 'some desc', 3)
})
</script>

<template>
  <div class="py-10">
    This is chat page
  </div>
</template>
