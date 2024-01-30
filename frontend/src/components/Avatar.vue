<script setup lang="ts">
import { EMPTY_ADDRESS } from '@/constants'

// @ts-expect-error no types
import jazzicon from '@metamask/jazzicon'

const props = defineProps<{
  address?: string
  size: number
}>()

const el = ref<HTMLDivElement>()
watchEffect(() => {
  jazz()
})

function jazz() {
  if (!el.value)
    return
  const sliced = (props?.address ?? EMPTY_ADDRESS).slice(2, 10)
  const seed = Number.parseInt(sliced, 16)
  el.value.replaceChildren(jazzicon(props.size, seed))
}
</script>

<template>
  <div ref="el" :style="{ height: `${size}px` }" />
</template>
