<script setup lang="ts">
import { fetchEscrow } from '@/lib/fetch'
import type { Escrow } from '@/types'

const store = useStore()
const escrows = shallowRef<Escrow[]>([])

async function fetch() {
  const _escrows: Escrow[] = []

  for (const id of store.user.escrowIds) {
    const escrow = await fetchEscrow(id)
    if (escrow)
      _escrows.push(escrow)
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
