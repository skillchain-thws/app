<script setup lang="ts">
import { ethers } from 'ethers'
import { Greeter__factory } from '../typechain/factories'

const deployedAddress = import.meta.env.VITE_DEPLOYED_ADDRESS
const accountAddress = import.meta.env.VITE_ACCOUNT_ADDRESS

const { provider, requestAccount } = useEthers()

const greeting = ref('')
const balance = ref('')

onMounted(async () => {
  getGreeting()
  balance.value = ethers.formatEther(await provider.value.getBalance(accountAddress))
})

async function getGreeting() {
  const factory = Greeter__factory.connect(deployedAddress, provider.value)
  const data = await factory.greet()
  greeting.value = data
}

async function setGreeting() {
  await requestAccount()
  const signer = await provider.value.getSigner()
  const factory = Greeter__factory.connect(deployedAddress, signer)
  const transaction = await factory.setGreeting(greeting.value)
  await transaction.wait()
  getGreeting()
}
</script>

<template>
  <div class="flex justify-center pt-10">
    <div class="space-y-5">
      <p>Balance: {{ balance }}</p>

      <form class="flex gap-x-2" @submit.prevent="setGreeting">
        <input v-model="greeting" type="text" class="px-1 text-black">

        <button class="bg-white px-6 py-2 text-black" @click="setGreeting">
          Set
        </button>
      </form>

      <button class="bg-white px-6 py-2 text-black" @click="getGreeting">
        Get
      </button>
    </div>
  </div>
</template>
