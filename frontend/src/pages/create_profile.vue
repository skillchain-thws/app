<script setup lang="ts">
import type { Profile } from '@/types'

const profile = ref<Profile>({
  title: '',
  description: '',
  badges: [],
  budget: 0,
  star: 5,
  ratingCount: 100,
})

const badgesStr = ref('')
watch(badgesStr, () => {
  profile.value.badges = badgesStr.value.trim().split(' ')
})

function onSubmit() {
  console.log(profile.value)
}
</script>

<template>
  <form class="grid grid-cols-2 gap-10 py-10 items-center" @submit.prevent="onSubmit">
    <div class="space-y-2">
      <div class="space-y-2">
        <Label for="title">title</Label>
        <Input id="title" v-model="profile.title" type="text" />
      </div>

      <div class="space-y-2">
        <Label for="description">description</Label>
        <Textarea id="description" v-model="profile.description" />
      </div>

      <div class="flex gap-3">
        <div class="w-[120px]">
          <div class="space-y-2">
            <Label for="budget">budget</Label>
            <Input id="budget" v-model.number="profile.budget" min="0" step="0.01" type="number" />
          </div>
        </div>

        <div class="grow space-y-2">
          <Label for="badges">badges</Label>
          <Input id="badges" v-model="badgesStr" type="text" />
        </div>
      </div>

      <Button>Create</Button>
    </div>

    <ProfileCard v-bind="profile" />
  </form>
</template>
