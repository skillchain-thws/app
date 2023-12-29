<script setup lang="ts">
import { useToast } from './ui/toast'

const store = useMMStore()
const router = useRouter()
const route = useRoute()
const { toast } = useToast()
await store.fetchUser()

watch(route, () => {
  if (store.isRegisterd || route.path === '/register')
    return

  router.push('/register')
  toast({ title: 'username is required', description: 'create now to explore skillchain' })
}, { immediate: true })
</script>

<template>
  <main class="relative min-h-[200px]">
    <RouterView />
  </main>
</template>
