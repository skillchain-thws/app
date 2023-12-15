<script setup lang="ts">
import type { Job } from '@/types'
import { Info } from 'lucide-vue-next'

defineProps<Job>()

const store = useMMStore()
</script>

<template>
  <Card class="group hover:border-primary transition-colors">
    <CardHeader>
      <CardTitle>
        <div class="flex justify-between items-center">
          <span class="break-words">
            {{ title }}
          </span>

          <TooltipProvider>
            <Tooltip>
              <TooltipTrigger>
                <Info :size="22" />
              </TooltipTrigger>
              <TooltipContent>
                <p>by: {{ store.address.toLowerCase() === owner.toLowerCase() ? 'me' : owner }}</p>
              </TooltipContent>
            </Tooltip>
          </TooltipProvider>
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
    <CardFooter>
      <div class="flex items-center">
        <span class="font-bold mr-0.5">
          eth {{ price }}
        </span>
        <Etherum />
      </div>
    </CardFooter>
  </Card>
</template>
