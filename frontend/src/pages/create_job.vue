<script setup lang="ts">
import type { Job } from '@/types'

const emptyJob = () => ({ title: '', description: '', tags: [], price: 0, id: 0, inProcess: false, owner: '0x0000000000000000000000000000000000000000' })
const job = ref<Job>(emptyJob())
const error = ref({ title: '', description: '' })

const tagsStr = ref('')
watch(tagsStr, () => {
  job.value.tags = tagsStr.value.trim().split(' ')
})

const store = useMMStore()
const jobFactory = await store.getJobFactory()
const { Comp, open } = useUsernameDialog()
const { user } = useUser()

async function handleCreateJob() {
  if (!user.value || !user.value.userName) {
    open()
    return
  }

  error.value = { title: '', description: '' }

  if (job.value.title && job.value.description) {
    await jobFactory.addJob(job.value.title, job.value.description, job.value.price, job.value.tags)
    job.value = emptyJob()
    tagsStr.value = ''
    return
  }

  if (!job.value.title)
    error.value.title = 'title is required'
  if (!job.value.description)
    error.value.description = 'description is required'
}
</script>

<template>
  <form class="grid grid-cols-2 gap-10 py-10 items-center" @submit.prevent="handleCreateJob">
    <div class="space-y-3">
      <div>
        <Label for="title" class="mb-3">title</Label>
        <Input id="title" v-model="job.title" type="text" />
        <p v-if="error.title" class="text-destructive mt-1">
          {{ error.title }}
        </p>
      </div>

      <div>
        <Label for="description" class="mb-3">description</Label>
        <Textarea id="description" v-model="job.description" />
        <p v-if="error.description" class="text-destructive mt-1">
          {{ error.description }}
        </p>
      </div>

      <div class="flex gap-3">
        <div class="w-[120px]">
          <div class="space-y-3">
            <Label for="budget">budget</Label>
            <Input id="budget" v-model.number="job.price" min="0" step="1" type="number" />
          </div>
        </div>

        <div class="grow space-y-3">
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

  <component :is="Comp" />
</template>
