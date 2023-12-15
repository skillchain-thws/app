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
const user = shallowRef<User>()
watchEffect(() => {
  if (user.value?.owner.toLowerCase() === props.job.owner.toLowerCase())
    return

  user.value = undefined
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
})
</script>

<template>
  <Sheet v-model:open="open">
    <SheetContent class="sm:max-w-xl">
      <SheetHeader>
        <SheetTitle>
          {{ job.title }} #{{ job.id }}
        </SheetTitle>
        <SheetDescription>
          {{ job.description }}
        </SheetDescription>
      </SheetHeader>

      <div class="pt-5 pb-2 flex gap-2 flex-wrap">
        <Badge v-for="(t, ti) in job.tags" :key="ti">
          {{ t }}
        </Badge>
      </div>

      <div class="flex items-center">
        <span class="font-bold mr-1">
          eth {{ job.price }}
        </span>
        <Etherum />
      </div>

      <Separator orientation="horizontal" class="my-5" />

      <div v-if="user">
        <div>
          <h3 class="text-xl">
            @{{ user.userName }}
          </h3>
        </div>

        <pre>
        {{ user }}
        </pre>
      </div>
    </SheetContent>
  </Sheet>
</template>
