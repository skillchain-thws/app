<script setup lang="ts">
import { EMPTY_ADDRESS } from '@/constants'
import type { Escrow } from '@/types'

const store = useStore()
const userFactory = await store.getUserFactory()
const escrowFactory = await store.getEscrowFactory()
const escrows = shallowRef<Escrow[]>([])

async function fetch() {
  const _escrows: Escrow[] = []

  const jobIds = await userFactory.getAllJobIds(store.address)
  for (const id of jobIds) {
    let escrowId: bigint
    try {
      escrowId = await escrowFactory.getEscrowIdFromJob(id)
    }
    catch {
      continue
    }
    const escrow = await escrowFactory.getEscrow(escrowId)
    const buyer = escrow[2]
    const seller = escrow[3]
    if (buyer === EMPTY_ADDRESS || seller === EMPTY_ADDRESS)
      continue

    _escrows.push({
      escrowId: Number(escrow[0]),
      jobId: Number(escrow[1]),
      buyer: escrow[2],
      seller: escrow[3],
      money: Number(escrow[4]),
      price: Number(escrow[5]),
      started: escrow[6],
      isDone: escrow[7],
    })
  }
  escrows.value = _escrows
}

onMounted(() => {
  fetch()
})
</script>

<template>
  <div class="py-10">
    <pre>
      {{ escrows }}
    </pre>
  </div>
</template>
