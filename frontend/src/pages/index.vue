<script setup lang="ts">
import { EMPTY_ADDRESS } from '@/constants'
import type { Job } from '@/types'
import { Heart } from 'lucide-vue-next'

const store = useStore()

const q = ref('')
const qDebounced = refDebounced(q, 500)
const showMyOnly = ref(false)
const sortOpt = ref<typeof sortOpts[number]['value']>('lth')
const sortOpts = [
  { label: 'price: low to high', value: 'lth' },
  { label: 'price: hight to low', value: 'htl' },
] as const

const jobFactory = await store.getJobFactory()
const jobs = shallowRef<Job[]>([])
const myJobs = computed(() => showMyOnly.value ? jobs.value.filter(j => j.owner.toLowerCase() === store.address.toLowerCase()) : jobs.value)
const data = computed(() => {
  const f = qDebounced.value
    ? myJobs.value.filter(j => JSON.stringify(j).toLowerCase().includes(q.value.toLowerCase()))
    : myJobs.value
  return f.sort((a, b) => {
    if (sortOpt.value === 'lth')
      return a.price - b.price
    return b.price - a.price
  })
})

onMounted(() => {
  jobFactory.getAllJobs().then((res) => {
    jobs.value = res
      .filter(x => x[0] !== EMPTY_ADDRESS)
      .map(j => ({
        owner: j[0],
        id: Number(j[1]),
        title: j[2],
        description: j[3],
        price: Number(j[4]),
        inProcess: j[5],
        tags: j[6],
      }))
  })
})

const isSheetOpen = ref(false)
const currentJob = shallowRef<Job>()
function handleOpenSheet(j: Job) {
  currentJob.value = j
  isSheetOpen.value = true
}
</script>

<template>
  <div>
    <div class="py-10">
      <BaseSearch v-model="q" placeholder="search for job title or keyword" />
    </div>

    <div class="py-8 space-y-8">
      <div class="flex justify-between items-center">
        <div class="flex items-center gap-3">
          <h1 class="text-4xl">
            jobs
          </h1>
          <Toggle v-model:pressed="showMyOnly" aria-label="toggle my job only">
            <Heart :size="20" />
          </Toggle>
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

      <ScrollArea class="h-[800px]">
        <div class="grid grid-cols-3 gap-6">
          <template v-if="jobs.length">
            <JobCard v-for="(job, i) in data" :key="i" v-bind="job" @click="handleOpenSheet(job)" />
          </template>

          <template v-else>
            <JobCardSkeleton v-for="i in 5" :key="i" />
          </template>
        </div>
      </ScrollArea>
    </div>

    <template v-if="currentJob">
      <KeepAlive>
        <JobSheet v-model:open="isSheetOpen" :job="currentJob" />
      </KeepAlive>
    </template>
  </div>
</template>
