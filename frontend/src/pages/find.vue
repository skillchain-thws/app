<script setup lang="ts">
import { Briefcase, Rows, Search } from 'lucide-vue-next'

const q = ref('')
const loc = ref('')
const type = ref('')
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
          <Input id="q" v-model="q" />
        </div>

        <Separator orientation="vertical" class="ml-4 mr-3" />

        <div class="flex gap-2 items-center grow">
          <Label for="type">
            <div class="w-10 h-10 border rounded-full flex-center shrink-0">
              <Briefcase :size="20" />
            </div>
          </Label>
          <Input id="type" v-model="type" />
        </div>

        <Separator orientation="vertical" class="ml-4 mr-3" />

        <div class="flex gap-2 items-center grow">
          <Label for="loc">
            <div class="w-10 h-10 border rounded-full flex-center shrink-0">
              <Rows :size="20" />
            </div>
          </Label>
          <Input id="loc" v-model="loc" />
        </div>

        <Separator orientation="vertical" class="ml-4 mr-3" />

        <div class="flex gap-2 items-center grow">
          <div class="w-10 h-10 border rounded-full flex-center shrink-0">
            <Rows :size="20" />
          </div>

          <Select>
            <SelectTrigger>
              <SelectValue placeholder="Select a fruit" />
            </SelectTrigger>
            <SelectContent>
              <SelectGroup>
                <SelectLabel>Fruits</SelectLabel>
                <SelectItem value="apple">
                  Apple
                </SelectItem>
              </SelectGroup>
            </SelectContent>
          </Select>
        </div>
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
              <CardTitle>notifications</CardTitle>
              <CardDescription>you have 3 unread messages.</CardDescription>
            </CardHeader>
            <CardContent>
              <div>
                something
              </div>
            </CardContent>
            <CardFooter>
              <Button class="w-full">
                mark all as read
              </Button>
            </CardFooter>
          </Card>
        </div>
      </ScrollArea>
    </div>
  </div>
</template>
