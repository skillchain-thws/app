<script setup lang="ts">
import { AcceptanceStatus, EMPTY_ADDRESS } from '@/constants'
import { fetchEscrows, fetchRequestDetails, fetchUser } from '@/lib/fetch'
import type { ReviewRequestDetail } from '@/types'
import { parseEther } from 'ethers'
import { ExternalLink } from 'lucide-vue-next'

type CustomReviewRequestDetail = ReviewRequestDetail & { requestUsername: string }

const q = ref('')
const qDebounced = refDebounced(q, 500)

const committees = ref<CustomReviewRequestDetail[]>([])

async function fetchCommitteeDetails(escrowId: number) {
  const d = await fetchRequestDetails(escrowId)
  if (d.requester === EMPTY_ADDRESS)
    return

  const user = await fetchUser(d.requester)
  return {
    ...d,
    requestUsername: user.userName,
  }
}

onMounted(async () => {
  const escrows = await fetchEscrows()
  const details = await Promise.all(escrows.map(e => fetchCommitteeDetails(e.escrowId)))
  committees.value = details.filter(Boolean) as CustomReviewRequestDetail[]
  console.log(parseEther('1.0'))
})
</script>

<template>
  <div>
    <div class="py-10">
      <BaseSearch v-model="q" placeholder="search for committees or keyword" />
    </div>

    <div class="pb-8 space-y-8">
      <h1 class="text-4xl">
        committees {{ qDebounced }}
      </h1>

      <Table>
        <TableCaption>a list of all committees</TableCaption>
        <colgroup>
          <col class="w-[10%]">
          <col class="w-[10%]">
          <col class="w-[60%]">
          <col class="w-[15%]">
          <col class="w-[5%]">
        </colgroup>
        <TableHeader>
          <TableRow>
            <TableHead>requester</TableHead>
            <TableHead>amount</TableHead>
            <TableHead>reason</TableHead>

            <TableHead class="text-center">
              status
            </TableHead>
            <TableHead />
          </TableRow>
        </TableHeader>
        <TableBody>
          <TableRow v-for="c in committees" :key="c.escrowId">
            <TableCell class="font-medium">
              {{ c.requestUsername }}
            </TableCell>
            <TableCell>
              <JobPrice>
                <template #parent>
                  <span class="mr-1">
                    {{ c.newAmount }}
                  </span>
                </template>
              </JobPrice>
            </TableCell>
            <TableCell>{{ c.reason }}</TableCell>
            <TableCell class="text-center">
              <template v-if="AcceptanceStatus[c.status] === 'Pending'">
                <Badge class="bg-yellow-500 dark:bg-yellow-400">
                  pending
                </Badge>
              </template>
              <template v-if="AcceptanceStatus[c.status] === 'Accepted'">
                <Badge class="bg-highlight">
                  accepted
                </Badge>
              </template>
              <template v-if="AcceptanceStatus[c.status] === 'Declined'">
                <Badge variant="destructive">
                  declined
                </Badge>
              </template>
            </TableCell>
            <TableCell>
              <RouterLink :to="{ path: `/committees/${c.escrowId}` }">
                <Button variant="ghost" size="icon">
                  <ExternalLink :size="20" />
                </Button>
              </RouterLink>
            </TableCell>
          </TableRow>
        </TableBody>
      </Table>
    </div>
  </div>
</template>
