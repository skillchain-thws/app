<script setup lang="ts">
import type { Job } from '@/types'
import { Search } from 'lucide-vue-next'

const q = ref('')
const qDebounced = refDebounced(q, 500)
const sortOpt = ref<typeof sortOpts[number]['value']>('lth')
const sortOpts = [
  { label: 'price: low to high', value: 'lth' },
  { label: 'price: hight to low', value: 'htl' },
] as const

const store = useMMStore()

const jobFactory = await store.getJobFactory()
const jobs = shallowRef<Job[]>([])
const data = computed(() => {
  const f = qDebounced.value
    ? jobs.value.filter(j => JSON.stringify(j).toLowerCase().includes(q.value.toLowerCase()))
    : jobs.value
  return f.sort((a, b) => {
    if (sortOpt.value === 'lth')
      return a.price - b.price
    return b.price - a.price
  })
})

function fetchJobs() {
  jobFactory.getAllJobs().then((res) => {
    jobs.value = res.map(j => ({
      title: j[2],
      description: j[3],
      price: Number(j[4]),
      tags: j[6],
    }))
  })
}

onMounted(() => {
  fetchJobs()
})
</script>

<template>
  <div>
    <div class="py-10">
      <div class="flex gap-2 items-center ">
        <Label for="q">
          <div class="w-10 h-10 border rounded-full flex-center shrink-0">
            <Search :size="20" />
          </div>
        </Label>
        <Input id="q" v-model="q" placeholder="search for job title or keyword" />
      </div>
    </div>

    <div class="py-8 space-y-8">
      <div class="flex justify-between items-center">
        <div>
          <h1 class="text-4xl">
            jobs
          </h1>
        </div>
        <div class="flex items-center whitespace-nowrap gap-2">
          <span class="text-muted-foreground">
            sort by:
          </span>

          <div class="min-w-[200px]">
            <Select v-model="sortOpt">
              <SelectTrigger>
                <SelectValue />
              </SelectTrigger>
              <SelectContent>
                <SelectGroup>
                  <SelectItem v-for="opt in sortOpts" :key="opt.value" :value="opt.value">
                    {{ opt.label }}
                  </SelectItem>
                </SelectGroup>
              </SelectContent>
            </Select>
          </div>
        </div>
      </div>

      <ScrollArea class="h-[500px]">
        <div class="grid grid-cols-3 gap-8">
          <template v-if="jobs.length">
            <RouterLink v-for="(job, i) in data" :key="i" class="group" to="/">
              <JobCard v-bind="job" />
            </RouterLink>
          </template>

          <template v-else>
            <JobCardSkeleton v-for="i in 5" :key="i" />
          </template>
        </div>
      </ScrollArea>
    </div>
  </div>
</template>
