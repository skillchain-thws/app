<script setup lang="ts">
import { fetchRequestDetails } from '@/lib/fetch'
import type { RouteLocationResolved } from 'vue-router/auto'

const route = useRoute()
const id = computed(() => +(route as RouteLocationResolved<'/committees/[id]'>).params.id)
const committee = computedAsync(async () => await fetchRequestDetails(id.value))
</script>

<template>
  <pre>{{ committee }}</pre>
</template>
