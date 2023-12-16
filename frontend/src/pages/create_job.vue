<script setup lang="ts">
import type { Job } from '@/types'

const emptyJob = () => ({ title: '', description: '', tags: [], price: 0, id: 0, inProcess: false, owner: '0x0000000000000000000000000000000000000000' })
const job = ref<Job>(emptyJob())

const tagsStr = ref('')
watch(tagsStr, () => {
  job.value.tags = tagsStr.value.trim().split(' ')
})

const router = useRouter()
const store = useMMStore()
const jobFactory = await store.getJobFactory()
const isDialogOpen = ref(false)
const userFactory = await store.getUserFactory()

onMounted(async () => {
  handleCheckUser()
})

async function handleCheckUser() {
  try {
    const user = await userFactory.getUser(store.address)
    if (!user[1]) {
      isDialogOpen.value = true
      return false
    }
  }
  catch {
    router.push('/error')
  }

  return true
}

async function handleCreateJob() {
  try {
    if (!await handleCheckUser())
      return
    await jobFactory.addJob(job.value.title, job.value.description, job.value.price, job.value.tags)
    job.value = emptyJob()
    tagsStr.value = ''
  }
  catch {
    router.push('/error')
  }
}

const username = ref('')
async function handleCreateUsername() {
  try {
    await userFactory.registerUser(username.value)
    isDialogOpen.value = false
  }
  catch {
    router.push('/error')
  }
}
</script>

<template>
  <form class="grid grid-cols-2 gap-10 py-10 items-center" @submit.prevent="handleCreateJob">
    <div class="space-y-3">
      <div class="space-y-2">
        <Label for="title">title</Label>
        <Input id="title" v-model="job.title" type="text" />
      </div>

      <div class="space-y-2">
        <Label for="description">description</Label>
        <Textarea id="description" v-model="job.description" />
      </div>

      <div class="flex gap-3">
        <div class="w-[120px]">
          <div class="space-y-2">
            <Label for="budget">budget</Label>
            <Input id="budget" v-model.number="job.price" min="0" step="1" type="number" />
          </div>
        </div>

        <div class="grow space-y-2">
          <Label for="badges">badges</Label>
          <Input id="badges" v-model="tagsStr" type="text" />
        </div>
      </div>

      <Button type="submit" class="w-full">
        Create
      </Button>
    </div>

    <div class="flex items-center justify-center">
      <div class="w-[80%]">
        <JobCard v-bind="job" class="w-full border-white transition-colors" />
      </div>
    </div>
  </form>

  <Dialog v-model:open="isDialogOpen">
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
