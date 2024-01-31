<script setup lang="ts">
import { EMPTY_ADDRESS } from '@/constants'
import { fetchRequestDetails } from '@/lib/fetch'
import type { RouteLocationResolved } from 'vue-router/auto'

const route = useRoute()
const router = useRouter()
const id = computed(() => +(route as RouteLocationResolved<'/committees/[id]'>).params.id)
const committee = computedAsync(async () => await fetchRequestDetails(id.value))
watch(committee, () => {
  if (committee.value.requester === EMPTY_ADDRESS)
    router.push('/committees')
})
</script>

<template>
  <pre>{{ committee }}</pre>
</template>
