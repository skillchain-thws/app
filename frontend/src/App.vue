<template>
  <div class="container my-8 border rounded-lg">
    <TheHeader />

    <main class="relative min-h-[200px]">
      <Suspense>
        <RouterView />
      </Suspense>
    </main>

    <Toaster />
  </div>
</template>
