<script setup lang="ts">
import type { ReviewRequestDetail } from '@/types'

const testId = 0
const store = useStore()
const committeeFactory = await store.getCommitteeFactory()
const reviewRequestDetails = ref<ReviewRequestDetail>()
const availableMembers = ref<string[]>([])

onMounted(async () => {
  const r = await committeeFactory.getReviewRequestDetails(testId)
  reviewRequestDetails.value = {
    requester: r[0],
    newAmount: Number([1]),
    reason: r[2],
    requiredCommitteeMembers: Number(r[3]),
    isClosed: r[4],
    status: Number(r[5]),
  }

  availableMembers.value = await committeeFactory.getAllAvailableCommitteeMembers()
  const randomMemberSet = new Set<string>()
  while (randomMemberSet.size < reviewRequestDetails.value.requiredCommitteeMembers) {
    const i = Math.floor(Math.random() * availableMembers.value.length)
    randomMemberSet.add(availableMembers.value[i])
  }
  await committeeFactory.setCommitteeMembers(testId, Array.from(randomMemberSet))
})
</script>

<template>
  <div class="py-10">
    <pre>
      {{ reviewRequestDetails }}
    </pre>
  </div>
</template>
