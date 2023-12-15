<script setup lang="ts">
// @ts-expect-error no types
import jazzicon from '@metamask/jazzicon'

const props = defineProps<{
  address: string
  size: number
}>()

const el = ref<HTMLDivElement>()
onMounted(() => {
  jazz()
})

watch(() => props.address, () => {
  jazz()
})

function jazz() {
  if (!el.value)
    return
  const sliced = props.address.slice(2, 10)
  const seed = Number.parseInt(sliced, 16)
  el.value.replaceChildren(jazzicon(props.size, seed))
}
</script>

<template>
  <div ref="el" />
</template>
