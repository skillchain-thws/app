<script setup lang="ts">
const store = useMMStore()
const jobFactory = await store.getJobFactory()
onMounted(async () => {
  const jobs = await jobFactory.getAllJobs()
  jobs.forEach((j) => {
    console.log(j[2])
    console.log(j[3])
    console.log(j[4])
  })
})
</script>

<template>
  <div class="py-10" />
</template>
