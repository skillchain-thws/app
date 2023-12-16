<script setup lang="ts">
import type { Job } from '@/types'

interface User {
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
const user = shallowRef<User>()
const userJobs = shallowRef<Job[]>([])
onMounted(() => {
  userFactory.getUser(props.job.owner).then((res) => {
    user.value = {
      owner: res[0],
      userName: res[1],
      isJudge: res[2],
      jobIds: res[3].map(Number),
      reviewsBuyerCount: Number(res[4]),
      reviewSellerCount: Number(res[5]),
    }
  })

  jobFactory.getAllJobsOfUser(props.job.owner).then((res) => {
    userJobs.value = res.map(x => ({
      owner: x[0],
      id: Number(x[1]),
      title: x[2],
      description: x[3],
      price: Number(x[4]),
      inProcess: x[5],
      tags: x[6],
    })).filter(x => x.id !== props.job.id)
  })
})

const message = ref('')
function handleSendRequest() {
  jobFactory.sendBuyRequest(props.job.id, message.value)
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

      <div class="flex items-center">
        <span class="font-bold mr-1">
          eth {{ job.price }}
        </span>
        <Etherum />
      </div>

      <form class="mt-3 space-y-3" @submit.prevent="handleSendRequest">
        <Textarea v-model="message" placeholder="leave a message" />
        <Button :disabled="job.owner.toLowerCase() === store.address.toLowerCase()" class="w-full" type="submit">
          send
        </Button>
      </form>

      <div v-if="user">
        <Separator orientation="horizontal" class="my-5" />

        <div class="space-y-2">
          <h3 class="text-xl">
            info
          </h3>

          <div class="grid grid-cols-3 gap-1">
            <div>username</div>
            <div class="col-span-2">
              <Badge variant="outline">
                {{ user.userName }}
              </Badge>
            </div>
            <div>address</div>
            <div class="col-span-2">
              <Badge variant="outline">
                {{ user.owner }}
              </Badge>
            </div>
            <div>is reviewer</div>
            <div class="col-span-2">
              <Badge variant="outline">
                {{ user.isJudge ? 'yes' : 'no' }}
              </Badge>
            </div>
            <div>buyer reviewed</div>
            <div class="col-span-2">
              <Badge variant="outline">
                {{ user.reviewsBuyerCount }}
              </Badge>
            </div>
            <div>seller reviewed</div>
            <div class="col-span-2">
              <Badge variant="outline">
                {{ user.reviewSellerCount }}
              </Badge>
            </div>
          </div>
        </div>

        <template v-if="userJobs.length">
          <Separator orientation="horizontal" class="mt-10 mb-5" />

          <div class="space-y-5">
            <h3 class="text-xl">
              more from @{{ user.userName }}
            </h3>

            <ScrollArea class="h-[400px]">
              <ul class="flex flex-col gap-3">
                <li v-for="(j, i) in userJobs" :key="i" class="px-3 py-2 rounded-md border">
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

                    <div class="flex items-center">
                      <span class="font-bold mr-1">
                        eth {{ j.price }}
                      </span>
                      <Etherum />
                    </div>
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
