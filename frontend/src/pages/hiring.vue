<script setup lang="ts">
import { profiles } from '@/includes/mocks'
import { Bookmark, Search, Star } from 'lucide-vue-next'

const q = ref('')
const sortOpt = ref<typeof sortOpts[number]['value']>('lth')
const sortOpts = [
  { label: 'price: low to high', value: 'lth' },
  { label: 'price: hight to low', value: 'htl' },
] as const

const data = computed(() => {
  const f = q.value
    ? profiles.filter(j =>
      j.title.toLowerCase().includes(q.value.toLowerCase())
      || j.description.toLowerCase().includes(q.value.toLowerCase()))
    : profiles
  return f.toSorted((a, b) => {
    if (sortOpt.value === 'lth')
      return a.budget - b.budget
    return b.budget - a.budget
  })
})
</script>

<template>
  <div>
    <div class="py-10 border-b">
      <div class="flex items-center h-[80px]">
        <div class="flex gap-2 items-center grow">
          <Label for="q">
            <div class="w-10 h-10 border rounded-full flex-center shrink-0">
              <Search :size="20" />
            </div>
          </Label>
          <Input id="q" v-model="q" placeholder="search for profile or keyword" />
        </div>
      </div>
    </div>

    <div class="py-8 space-y-8">
      <div class="flex justify-between items-center">
        <div>
          <h1 class="text-4xl">
            profiles
          </h1>
        </div>
        <div class="flex items-center whitespace-nowrap gap-2">
          <span class="text-muted-foreground">
            sort by:
          </span>

          <div class="min-w-[200px]">
            <Select v-model="sortOpt">
              <SelectTrigger>
                <SelectValue />
              </SelectTrigger>
              <SelectContent>
                <SelectGroup>
                  <SelectItem v-for="opt in sortOpts" :key="opt.value" :value="opt.value">
                    {{ opt.label }}
                  </SelectItem>
                </SelectGroup>
              </SelectContent>
            </Select>
          </div>
        </div>
      </div>

      <ScrollArea class="h-[500px]">
        <div class="grid grid-cols-3 gap-8">
          <RouterLink v-for="({ title, badges, budget, description, ratingCount, star }, i) in data" :key="i" class="group" to="/">
            <Card class="group-hover:border-primary transition-colors">
              <CardHeader>
                <CardTitle>
                  <div class="flex justify-between">
                    <span class="lowercase">
                      {{ title }}
                    </span>

                    <Bookmark :size="22" class="hover:fill-white" />
                  </div>
                </CardTitle>
                <CardDescription class="pt-2 space-x-2">
                  <Badge v-for="(badge, bi) in badges" :key="bi" variant="secondary">
                    {{ badge }}
                  </Badge>
                </CardDescription>
              </CardHeader>
              <CardContent>
                <div>
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
                  <span class="text-muted-foreground mr-1">
                    from
                  </span>
                  <span class="font-bold mr-0.5">
                    eth {{ budget }}
                  </span>
                  <Etherum />
                </div>
              </CardFooter>
            </Card>
          </RouterLink>
        </div>
      </ScrollArea>
    </div>
  </div>
</template>
