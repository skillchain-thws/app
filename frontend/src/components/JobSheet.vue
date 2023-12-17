<script setup lang="ts">
import type { Job } from '@/types'

interface Seller {
  owner: string
  userName: string
  isJudge: boolean
  jobIds: number[]
  reviewsBuyerCount: number
  reviewSellerCount: number
}

const props = defineProps<{
  job: Job
}>()

const open = defineModel({ default: false })

const store = useMMStore()
const userFactory = await store.getUserFactory()
const jobFactory = await store.getJobFactory()
const seller = shallowRef<Seller>()
const otherJobs = shallowRef<Job[]>([])

watch(
  () => props.job.owner
  , () => {
    seller.value = undefined
    otherJobs.value = []

    userFactory.getUser(props.job.owner).then((res) => {
      seller.value = {
        owner: res[0],
        userName: res[1],
        isJudge: res[2],
        jobIds: res[3].map(Number),
        reviewsBuyerCount: Number(res[4]),
        reviewSellerCount: Number(res[5]),
      }
    })

    jobFactory.getAllJobsOfUser(props.job.owner).then((res) => {
      otherJobs.value = res.map(x => ({
        owner: x[0],
        id: Number(x[1]),
        title: x[2],
        description: x[3],
        price: Number(x[4]),
        inProcess: x[5],
        tags: x[6],
      })).filter(x => x.id !== props.job.id)
    })
  },
  { immediate: true },
)

const message = ref('')
const error = ref('')
async function handleSendRequest() {
  if (!message.value) {
    error.value = 'message is required'
    return
  }

  await jobFactory.sendBuyRequest(props.job.id, message.value)
  message.value = ''
}

async function hanldeDeleteJob() {
  await jobFactory.deleteJob(props.job.id)
}
</script>

<template>
  <Sheet v-model:open="open">
    <SheetContent class="sm:max-w-lg">
      <SheetHeader>
        <SheetTitle>
          {{ job.title }} #{{ job.id }}
        </SheetTitle>
        <SheetDescription>
          {{ job.description }}
        </SheetDescription>
      </SheetHeader>

      <div class="pt-5 pb-2 flex gap-2 flex-wrap">
        <Badge v-for="(t, ti) in job.tags" :key="ti" variant="secondary">
          {{ t }}
        </Badge>
      </div>

      <JobPrice>
        {{ job.price }}
      </JobPrice>

      <template v-if="job.owner.toLowerCase() !== store.address.toLowerCase()">
        <form class="mt-3 space-y-3" @submit.prevent="handleSendRequest">
          <div class="space-y-1">
            <Textarea v-model="message" placeholder="leave a message" />
            <p v-if="error" class="text-destructive">
              {{ error }}
            </p>
          </div>

          <Button
            class="w-full" type="submit"
          >
            send
          </Button>
        </form>
      </template>

      <template v-else>
        <Button class="w-full mt-3" variant="destructive" @click="hanldeDeleteJob">
          delete
        </Button>
      </template>

      <div v-if="seller">
        <div class="space-y-2 mt-10">
          <h3 class="text-xl">
            info
          </h3>

          <div class="grid grid-cols-3 gap-1">
            <div>username</div>
            <div class="col-span-2">
              <Badge variant="outline">
                {{ seller.userName }}
              </Badge>
            </div>
            <div>address</div>
            <div class="col-span-2">
              <Badge variant="outline">
                {{ seller.owner }}
              </Badge>
            </div>
            <div>is reviewer</div>
            <div class="col-span-2">
              <Badge variant="outline">
                {{ seller.isJudge ? 'yes' : 'no' }}
              </Badge>
            </div>
            <div>buyer reviewed</div>
            <div class="col-span-2">
              <Badge variant="outline">
                {{ seller.reviewsBuyerCount }}
              </Badge>
            </div>
            <div>seller reviewed</div>
            <div class="col-span-2">
              <Badge variant="outline">
                {{ seller.reviewSellerCount }}
              </Badge>
            </div>
          </div>
        </div>

        <template v-if="otherJobs.length">
          <div class="space-y-5 mt-10">
            <h3 class="text-xl">
              more from @{{ seller.userName }}
            </h3>

            <ScrollArea class="h-[400px]">
              <ul class="flex flex-col gap-3">
                <li v-for="(j, i) in otherJobs" :key="i" class="px-3 py-2 rounded-md border">
                  <div class="space-y-2">
                    <div class="space-y-2">
                      <p>{{ j.title }}</p>
                      <ul class="-ml-2 flex gap-2">
                        <li v-for="(t, ti) in j.tags" :key="ti">
                          <Badge variant="outline">
                            {{ t }}
                          </Badge>
                        </li>
                      </ul>
                    </div>

                    <JobPrice>
                      {{ j.price }}
                    </JobPrice>
                  </div>
                </li>
              </ul>
            </ScrollArea>
          </div>
        </template>
      </div>
    </SheetContent>
  </Sheet>
</template>
