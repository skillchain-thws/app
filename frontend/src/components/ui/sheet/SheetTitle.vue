<script setup lang="ts">
import { cn } from '@/lib/utils'
import { DialogTitle, type DialogTitleProps } from 'radix-vue'

const props = defineProps<DialogTitleProps & { class?: string }>()
</script>

<template>
  <DialogTitle
    :class="cn('text-2xl font-semibold text-foreground', props.class)"
    v-bind="props"
  >
    <slot />
  </DialogTitle>
</template>
