<script setup lang="ts">
import type { VariantProps } from 'class-variance-authority'
import type { ToastRootEmits, ToastRootProps } from 'radix-vue'
import { ToastRoot, useEmitAsProps } from 'radix-vue'

import { cn } from '@/lib/utils'
import { toastVariants } from '.'

interface ToastVariantProps extends VariantProps<typeof toastVariants> {}

export interface ToastProps extends ToastRootProps {
  class?: string
  variant?: ToastVariantProps['variant']
  'onOpenChange'?: ((value: boolean) => void) | undefined
};

const props = defineProps<ToastProps>()
const emits = defineEmits<ToastRootEmits>()
</script>

<template>
  <ToastRoot
    v-bind="{ ...props, ...useEmitAsProps(emits) }"
    :class="cn(toastVariants({ variant: props.variant }), props.class)"
    @update:open="onOpenChange"
  >
    <slot />
  </ToastRoot>
</template>
