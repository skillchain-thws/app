<template>
  <div class="container my-8 border rounded-md">
    <TheHeader />

    <Suspense>
      <TheMain />
    </Suspense>

    <Toaster />
  </div>
</template>
