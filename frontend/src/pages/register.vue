<script setup lang="ts">
import { Input } from '@/components/ui/input'

const store = useMMStore()
const router = useRouter()
const userFactory = await store.getUserFactory()
const input = ref<InstanceType<typeof Input>>()
const username = ref('')

onMounted(() => {
  input.value?.$el.focus()
  watch(() => store.isRegisterd, () => {
    if (store.isRegisterd)
      router.push('/')
  })
})

async function handleCreateUsername() {
  const response = await userFactory.registerUser(username.value)
  const receipt = await response.wait()
  if (receipt?.status === 1) {
    await store.fetchUser()
    router.push('/')
  }
}
</script>

<template>
  <div class="py-10 flex justify-center items-center">
    <div class="w-1/3 border rounded-md">
      <form class="p-5" @submit.prevent="handleCreateUsername">
        <h1 class="font-medium text-xl">
          welcome to freelancer
        </h1>
        <p class="text-muted-foreground text-sm mt-0.5">
          you first need to create a username
        </p>
        <Input ref="input" v-model="username" class="mt-5" placeholder="username" />
        <Button class="mt-3 w-full">
          register
        </Button>
      </form>
    </div>
  </div>
</template>
