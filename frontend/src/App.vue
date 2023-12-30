<script setup lang="ts">
const store = useStore()
const isEthereum = !!window.ethereum
</script>

<template>
  <div class="container my-8 border rounded-md">
    <TheHeader />

    <Suspense v-if="isEthereum && store.isConnected">
      <TheMain />
    </Suspense>

    <div v-else-if="!isEthereum" class="h-[400px] flex justify-center items-center">
      <div class="flex flex-col items-center justify-center">
        <Metamask class="text-9xl" />
        <p class="mt-5">
          metamask is not installed
        </p>
        <a href="https://metamask.io/download/" target="_blank">
          <Button variant="link">
            install now
          </Button>
        </a>
      </div>
    </div>

    <div v-else-if="!store.isConnected" class="h-[400px] flex justify-center items-center">
      <div class="flex flex-col items-center justify-center space-y-5">
        <Metamask class="text-9xl" />

        <p>you are not connected</p>

        <Button @click="store.connect">
          connect
        </Button>
      </div>
    </div>

    <Toaster />
  </div>
</template>
