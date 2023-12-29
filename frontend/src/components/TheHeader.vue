<script setup lang="ts">
import { Link, Moon, Sun } from 'lucide-vue-next'

const isDark = useDark()
const store = useMMStore()
const balance = ref('0')
onMounted(() => {
  store.connect().then(() => {
    store.getBalance().then((b) => {
      balance.value = (b / 1e18).toFixed(4)
    })
  })
})
</script>

<template>
  <nav class="flex items-center border-b">
    <RouterLink to="/" class="flex items-center gap-2 w-1/4">
      <Link :size="23" class="text-primary" />
      <span class="text-2xl tracking-wide">skillchain</span>
    </RouterLink>

    <ul class="flex items-center gap-8 justify-between text-lg h-[100px] whitespace-nowrap">
      <RouterLink to="/" class="grow flex-center h-full border-b border-transparent hover:border-primary transition-[border] min-w-[80px]" active-class="border-b-primary">
        find job
      </RouterLink>
      <RouterLink to="/create_job" class="grow flex-center h-full border-b border-transparent hover:border-primary transition-[border] min-w-[80px]" active-class="border-b-primary">
        create job
      </RouterLink>
      <RouterLink to="/chat" class="grow flex-center h-full border-b border-transparent hover:border-primary transition-[border] min-w-[80px]" active-class="border-b-primary">
        chat
      </RouterLink>

      <RouterLink to="/requests" class="grow flex-center h-full border-b border-transparent hover:border-primary transition-[border] min-w-[80px]" active-class="border-b-primary">
        requests
      </RouterLink>

      <RouterLink to="/review" class="grow flex-center h-full border-b border-transparent hover:border-primary transition-[border] min-w-[80px]" active-class="border-b-primary">
        review
      </RouterLink>
    </ul>

    <div class="ml-auto flex items-center gap-8">
      <button class="block" @click="isDark = !isDark">
        <Moon v-if="isDark" :size="22" />
        <Sun v-else :size="22" />
      </button>
      <template v-if="store.isConnected">
        <div class="flex items-center gap-2.5 text-sm shrink-0">
          <div>
            <p class="text-base text-muted-foreground">
              {{ store.shortAddress }}
            </p>
            <JobPrice>{{ balance }}</JobPrice>
          </div>
          <Avatar :size="42" :address="store.address" />
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
