<script setup lang="ts">
import type { Job } from '@/types'

const job = ref<Job>({
  title: '',
  description: '',
  tags: [],
  price: 0,
})

const tagsStr = ref('')
watch(tagsStr, () => {
  job.value.tags = tagsStr.value.trim().split(' ')
})

const store = useMMStore()
const jobFactory = await store.getJobFactory()

onMounted(async () => {
  try {
    // const userFactory = await store.getUserFactory()
    // await userFactory.registerUser('real_acc')
    // const user = await userFactory.getUser('0x70997970C51812dc3A010C7d01b50e0d17dc79C8')
    // console.log(user)
  }
  catch (e) {

  }
})

async function onSubmit() {
  jobFactory.addJob(job.value.title, job.value.description, job.value.price, job.value.tags)
}

const isDialogOpen = ref(false)
</script>

<template>
  <form class="grid grid-cols-2 gap-10 py-10 items-center" @submit.prevent="onSubmit">
    <div class="space-y-2">
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
        <JobCard v-bind="job" class="w-full hover:border-white transition-colors" />
      </div>
    </div>
  </form>

  <Dialog :open="isDialogOpen">
    <DialogContent>
      <DialogHeader>
        <DialogTitle>Edit profile</DialogTitle>
        <DialogDescription>
          Make changes to your profile here. Click save when you're done.
        </DialogDescription>
      </DialogHeader>

      <DialogFooter>
        Save changes
      </DialogFooter>
    </DialogContent>
  </Dialog>
</template>
