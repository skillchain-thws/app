<script setup lang="ts">
import type { Job } from '@/types'

defineProps<Job>()
</script>

<template>
  <Card class="group flex flex-col cursor-pointer hover:border-primary transition-colors">
    <CardHeader>
      <CardTitle>
        <div class="flex justify-between items-center">
          <span class="break-words tracking-wide">
            {{ title }}
          </span>
        </div>
      </CardTitle>

      <CardDescription class="pt-2 flex gap-2 flex-wrap">
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
      <JobPrice>
        {{ toETH(price) }}
      </JobPrice>
    </CardFooter>
  </Card>
</template>
