<script setup lang="ts">
const open = defineModel({ default: false })
const username = ref('')

const store = useMMStore()
const router = useRouter()
const userFactory = await store.getUserFactory()

async function handleCreateUsername() {
  try {
    await userFactory.registerUser(username.value)
    open.value = false
  }
  catch {
    router.push('/error')
  }
}
</script>

<template>
  <Dialog v-model:open="open">
    <DialogContent>
      <DialogHeader>
        <DialogTitle>no username</DialogTitle>
        <DialogDescription>
          you first need to create a username
        </DialogDescription>
      </DialogHeader>

      <form id="create_username" @submit.prevent="handleCreateUsername">
        <Input v-model="username" placeholder="username" />
      </form>

      <DialogFooter>
        <DialogClose>
          <Button form="create_username">
            create
          </Button>
        </DialogClose>
      </DialogFooter>
    </DialogContent>
  </Dialog>
</template>
