<script setup lang="ts">
import type { Job } from '@/types'

const job = ref<Job>({
  title: '',
  description: '',
  tags: [],
  price: 0,
})

const badgesStr = ref('')
watch(badgesStr, () => {
  job.value.tags = badgesStr.value.trim().split(' ')
})

const store = useMMStore()
const factory = await store.getJobFactory()

async function onSubmit() {
  factory.addJob(job.value.title, job.value.description, job.value.price, job.value.tags)
}
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
          <Input id="badges" v-model="badgesStr" type="text" />
        </div>
      </div>

      <Button type="submit">
        Create
      </Button>
    </div>

    <div>
      <JobCard v-bind="job" />
    </div>
  </form>
</template>
