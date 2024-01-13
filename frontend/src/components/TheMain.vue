<script setup lang="ts">
import { fetchUser } from '@/lib/fetch'
import { useToast } from './ui/toast'

const store = useStore()
const router = useRouter()
const route = useRoute()
const { toast } = useToast()
if (store.isConnected)
  store.user = await fetchUser(store.address)

watch(route, () => {
  if (store.isRegistered || route.path === '/register')
    return

  router.push('/register')
  toast({ title: 'username is required', description: 'create now to explore skillchain' })
}, { immediate: true })
</script>

<template>
  <main class="relative min-h-[400px]">
    <RouterView />
  </main>
</template>
