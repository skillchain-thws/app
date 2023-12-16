<script setup lang="ts">
import type { Job } from '@/types'

defineProps<Job>()
</script>

<template>
  <Card class="group flex flex-col cursor-pointer hover:border-primary transition-colors">
    <CardHeader>
      <CardTitle>
        <div class="flex justify-between items-center">
          <span class="break-words">
            {{ title }}
          </span>
        </div>
      </CardTitle>

      <CardDescription class="pt-2 space-x-2">
        <template v-for="(t, ti) in tags">
          <Badge v-if="t" :key="ti" variant="secondary">
            {{ t }}
          </Badge>
        </template>
      </CardDescription>
    </CardHeader>

    <CardContent>
      <div class="break-words">
        {{ description }}
      </div>
    </CardContent>

    <CardFooter class="mt-auto">
      <div class="flex items-center">
        <span class="font-bold mr-0.5">
          eth {{ price }}
        </span>
        <Etherum />
      </div>
    </CardFooter>
  </Card>
</template>
