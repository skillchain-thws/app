<script setup lang="ts">
import { Egg } from 'lucide-vue-next'

const store = useMMStore()

watchEffect(() => store.connect())
</script>

<template>
  <nav class="flex items-center border-b">
    <RouterLink to="/" class="flex items-center gap-2 w-1/3">
      <Egg :size="26" class=" fill-white" />
      <span class="text-2xl tracking-wide">freelancer</span>
    </RouterLink>

    <ul class="flex items-center gap-8 justify-between text-lg h-[100px] whitespace-nowrap">
      <RouterLink to="/" class="grow flex-center h-full border-b border-transparent hover:border-white transition-[border] min-w-[80px]" active-class="border-white">
        find job
      </RouterLink>
      <RouterLink to="/create_job" class="grow flex-center h-full border-b border-transparent hover:border-white transition-[border] min-w-[80px]" active-class="border-white">
        create job
      </RouterLink>
      <RouterLink to="/chat" class="grow flex-center h-full border-b border-transparent hover:border-white transition-[border] min-w-[80px]" active-class="border-white">
        chat
      </RouterLink>

      <RouterLink to="/requests" class="grow flex-center h-full border-b border-transparent hover:border-white transition-[border] min-w-[80px]" active-class="border-white">
        requests
      </RouterLink>
    </ul>

    <div class="ml-auto">
      <template v-if="store.isConnected">
        <div class="flex items-center gap-3">
          <p class="text-lg text-muted-foreground">
            {{ store.shortAddress }}
          </p>
          <Avatar :size="40" :address="store.address" />
        </div>
      </template>

      <template v-else>
        <Button @click="store.connect()">
          <div class="flex items-center gap-1.5">
            <Metamask class="text-lg" />
            connect
          </div>
        </Button>
      </template>
    </div>
  </nav>
</template>
