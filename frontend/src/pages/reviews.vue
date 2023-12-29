<script setup lang="ts">
import { EMPTY_ADDRESS } from '@/constants'
import type { Escrow } from '@/types'

const store = useMMStore()
const userFactory = await store.getUserFactory()
const escrowFactory = await store.getEscrowFactory()

async function fetch() {
  const escrows: Escrow[] = []
  const jobIds = await userFactory.getAllJobIds(store.address)
  for (const id of jobIds) {
    let escrowId
    try {
      escrowId = await escrowFactory.getEscrowIdFromJob(id)
    }
    catch {
      continue
    }
    const escrow = await escrowFactory.getEscrow(escrowId)
    const buyer = escrow[1]
    const seller = escrow[2]
    if (buyer === EMPTY_ADDRESS || seller === EMPTY_ADDRESS)
      continue

    escrows.push({
      jobId: Number(escrow[0]),
      buyer: escrow[1],
      seller: escrow[2],
      money: Number(escrow[3]),
      started: escrow[4],
      buyerAccepted: escrow[5],
      sellerAccepted: escrow[6],
    })
  }
  console.log(escrows)
}

onMounted(() => {
  fetch()
})
</script>

<template>
  <div class="py-10">
    <template v-if="store.user?.isJudge">
      User is reviewer
    </template>
  </div>
</template>
