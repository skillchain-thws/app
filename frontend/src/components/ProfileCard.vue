<script setup lang="ts">
import type { Profile } from '@/types'
import { Bookmark, Star } from 'lucide-vue-next'

defineProps<Profile>()
</script>

<template>
  <Card class="group-hover:border-primary transition-colors">
    <CardHeader>
      <CardTitle>
        <div class="flex justify-between">
          <span class="break-words">
            {{ title }}
          </span>

          <Bookmark :size="22" class="hover:fill-white" />
        </div>
      </CardTitle>
      <CardDescription class="pt-2 space-x-2">
        <template v-for="(b, bi) in badges">
          <Badge v-if="b" :key="bi" variant="secondary">
            {{ b }}
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
      <div class="flex items-center gap-2">
        <Star class="fill-white -mt-0.5" :size="20" />
        <span class="font-bold text-lg">{{ star }}</span>
        <span class="text-muted-foreground">({{ ratingCount }})</span>
      </div>

      <div class="mt-2 flex items-center">
        <span class="font-bold mr-0.5">
          eth {{ budget }}
        </span>
        <Etherum />
      </div>
    </CardFooter>
  </Card>
</template>
