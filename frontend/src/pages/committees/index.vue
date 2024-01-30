<script setup lang="ts">
import { AcceptanceStatus, EMPTY_ADDRESS } from '@/constants'
import { fetchEscrows, fetchRequestDetails } from '@/lib/fetch'
import type { ReviewRequestDetail } from '@/types'

const q = ref('')
const qDebounced = refDebounced(q, 500)

const committees = ref<ReviewRequestDetail[]>([])

onMounted(async () => {
  committees.value = (await Promise.all(
    (await fetchEscrows())
      .map(e => fetchRequestDetails(e.escrowId)),
  ))
    .filter(x => x.requester !== EMPTY_ADDRESS)
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
        <TableHeader>
          <TableRow>
            <TableHead>requester</TableHead>
            <TableHead>amount</TableHead>
            <TableHead>reason</TableHead>
            <TableHead>member count</TableHead>
            <TableHead>status</TableHead>
            <TableHead>go</TableHead>
          </TableRow>
        </TableHeader>
        <TableBody>
          <TableRow v-for="c in committees" :key="c.escrowId">
            <TableCell>abc</TableCell>
            <TableCell>{{ c.newAmount }}</TableCell>
            <TableCell>{{ c.reason }}</TableCell>
            <TableCell>{{ c.requiredCommitteeMembers }}</TableCell>
            <TableCell>
              <template v-if="AcceptanceStatus[c.status] === 'Pending'">
                <Badge class="bg-yellow-500 dark:bg-yellow-400">
                  Pending
                </Badge>
              </template>
              <template v-if="AcceptanceStatus[c.status] === 'Accepted'">
                <Badge class="bg-highlight">
                  Accepted
                </Badge>
              </template>
              <template v-if="AcceptanceStatus[c.status] === 'Declined'">
                <Badge variant="destructive">
                  Declined
                </Badge>
              </template>
            </TableCell>
            <TableCell>
              <RouterLink :to="{ path: `/committees/${c.escrowId}` }">
                to
              </RouterLink>
            </TableCell>
          </TableRow>
        </TableBody>
      </Table>
    </div>
  </div>
</template>
