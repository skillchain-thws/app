<script setup lang="ts">
import { Briefcase, Check, Rows, Search } from 'lucide-vue-next'

const q = ref('')
const loc = ref('')
const type = ref('')
</script>

<template>
  <div>
    <div class="py-10 -mx-8 border-b">
      <div class="flex items-center gap-8 h-[80px] px-8">
        <div class="flex gap-2 items-center">
          <Label for="q">
            <div class="w-10 h-10 border rounded-full flex-center">
              <Search :size="20" />
            </div>
          </Label>
          <Input id="q" v-model="q" />
        </div>

        <Separator orientation="vertical" />

        <div class="flex gap-2 items-center">
          <Label for="type">
            <div class="w-10 h-10 border rounded-full flex-center">
              <Briefcase :size="20" />
            </div>
          </Label>
          <Input id="type" v-model="type" />
        </div>

        <Separator orientation="vertical" />

        <div class="flex gap-2 items-center">
          <Label for="loc">
            <div class="w-10 h-10 border rounded-full flex-center">
              <Rows :size="20" />
            </div>
          </Label>
          <Input id="loc" v-model="loc" />
        </div>

        <Separator orientation="vertical" />
      </div>
    </div>

    <div class="py-8 space-y-8">
      <div class="flex justify-between items-center">
        <div>
          <h1 class="text-4xl">
            jobs
          </h1>
        </div>
        <div>
          sort
        </div>
      </div>

      <ScrollArea class="h-[500px]">
        <div class="grid grid-cols-3 gap-8">
          <Card v-for="i in 20" :key="i">
            <CardHeader>
              <CardTitle>Notifications</CardTitle>
              <CardDescription>You have 3 unread messages.</CardDescription>
            </CardHeader>
            <CardContent>
              <div>
                Something
              </div>
            </CardContent>
            <CardFooter>
              <Button class="w-full">
                <Check class="mr-2 h-4 w-4" /> Mark all as read
              </Button>
            </CardFooter>
          </Card>
        </div>
      </ScrollArea>
    </div>
  </div>
</template>
