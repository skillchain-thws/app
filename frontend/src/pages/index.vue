<script setup lang="ts">
import { Greeter__factory } from '../typechain/factories'

const deployedAddress = import.meta.env.VITE_DEPLOYED_ADDRESS

const { signer, provider } = useEthers()
const greeting = ref('')

async function getGreeting() {
  const factory = Greeter__factory.connect(deployedAddress, provider.value)
  const data = await factory.greet()
  greeting.value = data
}

async function setGreeting() {
  const factory = Greeter__factory.connect(deployedAddress, signer.value)
  const transaction = await factory.setGreeting(greeting.value)
  await transaction.wait()
  getGreeting()
}
</script>

<template>
  <div class="flex justify-center pt-10">
    <div class="space-y-5">
      <form class="flex gap-x-2" @submit.prevent="setGreeting">
        <Input v-model="greeting" type="text" />

        <Button>
          Set
        </Button>
      </form>

      <Button @click="getGreeting">
        Get
      </Button>
    </div>
  </div>
</template>
