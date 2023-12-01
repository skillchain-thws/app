<script setup lang="ts">
import { useToast } from '@/components/ui/toast/use-toast'
import { MetaMaskConnector, shortenAddress, useWalletStore } from '@vue-dapp/core'
import { Egg } from 'lucide-vue-next'

// @ts-expect-error no types
import jazzicon from '@metamask/jazzicon'

const { toast } = useToast()
const store = useWalletStore()
const avatar = shallowRef<HTMLDivElement>()

async function handleConnectMM() {
  try {
    await store.connectWith(new MetaMaskConnector())
    const addr = store.address.slice(2, 10)
    const seed = Number.parseInt(addr, 16)
    const icon = jazzicon(35, seed)
    avatar.value && avatar.value.replaceWith(icon)
  }
  catch (e) {
    toast({
      description: store.error,
      variant: 'destructive',
    })
  }
}
</script>

<template>
  <nav class="flex justify-between items-center border-b">
    <div class="flex items-center gap-40">
      <RouterLink to="/" class="flex items-center gap-2">
        <Egg :size="26" class=" fill-white" />
        <span class="text-2xl tracking-wide">freelancer</span>
      </RouterLink>

      <ul class="flex items-center gap-8 justify-between text-lg h-[100px]">
        <RouterLink to="/" class="grow flex-center h-full border-b border-transparent hover:border-white transition-[border]" active-class="border-white">
          find job
        </RouterLink>
        <RouterLink to="/hiring" class="grow flex-center h-full border-b border-transparent hover:border-white transition-[border]" active-class="border-white">
          hiring
        </RouterLink>
        <RouterLink to="/chat" class="grow flex-center h-full border-b border-transparent hover:border-white transition-[border]" active-class="border-white">
          chat
        </RouterLink>
        <RouterLink to="/create_job" class="grow flex-center h-full border-b border-transparent hover:border-white transition-[border]" active-class="border-white">
          create job
        </RouterLink>
        <RouterLink to="/create_profile" class="grow flex-center h-full border-b border-transparent hover:border-white transition-[border]" active-class="border-white">
          create profile
        </RouterLink>
      </ul>
    </div>

    <div>
      <template v-if="store.isConnected">
        <div class="flex items-center gap-2">
          <span class="text-muted-foreground">{{ shortenAddress(store.address) }}</span>
          <div ref="avatar" />
        </div>
      </template>

      <template v-else>
        <Button @click="handleConnectMM">
          <div class="flex items-center gap-1">
            <Metamask class="text-lg" />
            connect
          </div>
        </Button>
      </template>
    </div>
  </nav>
</template>
