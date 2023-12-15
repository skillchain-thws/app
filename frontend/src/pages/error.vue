<script setup lang="ts">
import { Undo2 } from 'lucide-vue-next'
</script>

<template>
  <div class="flex items-center justify-center absolute inset-0">
    <div class="text-center">
      <div class="text-4xl">
        Error
      </div>

      <RouterLink to="/">
        <Button variant="link">
          <Undo2 :size="16" class="mr-2" />
          back to homepage
        </Button>
      </RouterLink>
    </div>
  </div>
</template>
