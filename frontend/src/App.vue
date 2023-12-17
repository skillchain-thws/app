<script setup lang="ts">
const store = useMMStore()
onMounted(() => {
  store.fetchUser()
})
</script>

<template>
  <div class="container my-8 border rounded-md">
    <TheHeader />

    <main class="relative min-h-[200px]">
      <Suspense>
        <RouterView />
      </Suspense>
    </main>

    <Toaster />
  </div>
</template>
