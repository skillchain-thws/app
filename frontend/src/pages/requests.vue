<script setup lang="ts">
import type { Job } from '@/types'
import { ChevronDown, CornerDownRight } from 'lucide-vue-next'

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
const router = useRouter()
onMounted(() => {
  if (!store.isRegisterd)
    router.push('/register')
})

const jobFactory = await store.getJobFactory()
const pendingJobs = shallowRef<CustomJob[]>([])
const acceptedJobs = shallowRef<CustomJob[]>([])

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

        const jobs = _jobs.reduce((acc, cur) => {
          if (cur.requests.some(r => r.accepted))
            acc.acceptedJobs.push(cur)
          else
            acc.pendingJobs.push(cur)
          return acc
        }, {
          pendingJobs: [] as CustomJob[],
          acceptedJobs: [] as CustomJob[],
        })

        pendingJobs.value = jobs.pendingJobs
        acceptedJobs.value = jobs.acceptedJobs
      })
  })

const jobId = ref<number>()
async function handleAcceptRequest(requestId: number) {
  if (jobId.value !== 0 && !jobId.value)
    return

  await jobFactory.acceptBuyRequest(jobId.value, requestId)
}
</script>

<template>
  <div class="py-10 space-y-10">
    <div>
      <h2 class="text-2xl font-medium flex items-center gap-1">
        pending <span class="text-muted-foreground text-base">
          ({{ pendingJobs.length }})
        </span>
      </h2>

      <template v-if="pendingJobs.length">
        <ScrollArea class="mt-5 h-[500px]">
          <ul class="space-y-5">
            <li v-for="j in pendingJobs" :key="j.id">
              <div class="px-5 py-3 border rounded-md grid grid-cols-11 gap-10">
                <div class="space-y-2 col-span-5">
                  <div class="font-medium">
                    {{ j.title }} #{{ j.id }}
                  </div>
                  <div class="text-muted-foreground">
                    {{ j.description }}
                  </div>
                </div>

                <div class="space-y-2 col-span-5">
                  <ul class="flex gap-2">
                    <li v-for="(t, ti) in j.tags" :key="ti">
                      <Badge variant="secondary">
                        {{ t }}
                      </Badge>
                    </li>
                  </ul>

                  <JobPrice>
                    {{ j.price }}
                  </JobPrice>
                </div>

                <div class="flex items-center justify-end">
                  <Button :disabled="!j.requests.length" variant="outline" size="icon" @click="jobId = jobId === j.id ? undefined : j.id">
                    <ChevronDown class="transition-transform" :class="{ 'rotate-180': j.id === jobId }" />
                  </Button>
                </div>
              </div>

              <Transition
                enter-active-class="transition-all duration-300"
                leave-active-class="transition-all duration-300"
                enter-from-class="opacity-0 translate-x-[10rem]"
                leave-to-class="opacity-0 translate-x-[10rem]"
              >
                <template v-if="j.requests.length && j.id === jobId">
                  <ul>
                    <li v-for="r in j.requests" :key="r.id">
                      <div class="w-[70%] ml-auto mt-5 flex gap-5 items-center">
                        <CornerDownRight :size="16" />

                        <div class="px-5 py-3 border rounded-md grow flex gap-5 items-center">
                          <div class="space-y-5 grow">
                            <div class="flex">
                              <span class="w-20 shrink-0">from</span>
                              <span class="font-medium"> {{ r.buyer }}</span>
                            </div>
                            <div class="flex">
                              <span class="w-20 shrink-0">message:</span>
                              <div class="px-3 py-2 bg-secondary border rounded-md grow">
                                {{ r.message }}
                              </div>
                            </div>
                          </div>

                          <Button :disabled="r.accepted" @click="handleAcceptRequest(r.id)">
                            accept
                          </Button>
                        </div>
                      </div>
                    </li>
                  </ul>
                </template>
              </Transition>
            </li>
          </ul>
        </ScrollArea>
      </template>
    </div>

    <div>
      <h2 class="text-2xl font-medium flex items-center gap-1">
        accepted <span class="text-muted-foreground text-base">
          ({{ acceptedJobs.length }})
        </span>
      </h2>

      <template v-if="acceptedJobs.length">
        <ScrollArea class="mt-5 h-[500px]">
          <ul class="space-y-5">
            <li v-for="j in acceptedJobs" :key="j.id">
              <div class="px-5 py-3 border rounded-md grid grid-cols-11 gap-10">
                <div class="space-y-2 col-span-5">
                  <div class="font-medium">
                    {{ j.title }} #{{ j.id }}
                  </div>
                  <div class="text-muted-foreground">
                    {{ j.description }}
                  </div>
                </div>

                <div class="space-y-2 col-span-5">
                  <ul class="flex gap-2">
                    <li v-for="(t, ti) in j.tags" :key="ti">
                      <Badge variant="secondary">
                        {{ t }}
                      </Badge>
                    </li>
                  </ul>

                  <JobPrice>
                    {{ j.price }}
                  </JobPrice>
                </div>

                <div class="flex items-center justify-end">
                  <Button :disabled="!j.requests.length" variant="outline" size="icon" @click="jobId = jobId === j.id ? undefined : j.id">
                    <ChevronDown class="transition-transform" :class="{ 'rotate-180': j.id === jobId }" />
                  </Button>
                </div>
              </div>

              <Transition
                enter-active-class="transition-all duration-300"
                leave-active-class="transition-all duration-300"
                enter-from-class="opacity-0 translate-x-[10rem]"
                leave-to-class="opacity-0 translate-x-[10rem]"
              >
                <template v-if="j.requests.length && j.id === jobId">
                  <ul>
                    <li v-for="r in j.requests" :key="r.id">
                      <div class="w-[70%] ml-auto mt-5 flex gap-5 items-center">
                        <CornerDownRight :size="16" />

                        <div class="px-5 py-3 border rounded-md grow flex gap-5 items-center">
                          <div class="space-y-5 grow">
                            <div class="flex">
                              <span class="w-20 shrink-0">from</span>
                              <span class="font-medium"> {{ r.buyer }}</span>
                            </div>
                            <div class="flex">
                              <span class="w-20 shrink-0">message:</span>
                              <div class="px-3 py-2 bg-secondary border rounded-md grow">
                                {{ r.message }}
                              </div>
                            </div>
                          </div>

                          <Button :disabled="r.accepted" @click="handleAcceptRequest(r.id)">
                            accept
                          </Button>
                        </div>
                      </div>
                    </li>
                  </ul>
                </template>
              </Transition>
            </li>
          </ul>
        </ScrollArea>
      </template>
    </div>
  </div>
</template>
