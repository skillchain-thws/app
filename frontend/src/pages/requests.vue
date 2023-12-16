<script setup lang="ts">
import type { Job } from '@/types'

interface Request {
  id: number
  buyer: string
  message: string
  accepted: boolean
}

interface CustomJob extends Job {
  requests: Request[]
}

const store = useMMStore()

const jobFactory = await store.getJobFactory()
const jobs = shallowRef<CustomJob[]>([])

jobFactory.getAllJobsOfUser(store.address)
  .then((res) => {
    const _jobs = res.map(x => ({
      owner: x[0],
      id: Number(x[1]),
      title: x[2],
      description: x[3],
      price: Number(x[4]),
      inProcess: x[5],
      tags: x[6],
      requests: [] as Request[],
    }))

    const promises = _jobs.map(job => jobFactory.getJobBuyRequests(job.id))
    Promise.all(promises)
      .then((res) => {
        res.forEach((x, i) => {
          const js = x.map(y => ({
            id: Number(y[1]),
            buyer: y[2],
            message: y[3],
            accepted: y[4],
          }))

          _jobs[i].requests.push(...js)
        })

        jobs.value = _jobs
      })
  })
</script>

<template>
  <div class="py-10">
    <h1 class="text-2xl font-medium">
      pending
    </h1>
    <pre>
      {{ jobs }}
    </pre>
  </div>
</template>
