<script setup lang="ts">
const store = useMMStore()
const router = useRouter()
onMounted(() => {
  if (!store.isRegisterd)
    router.push('/register')
})

// const escrowFactory = await store.getEscrowFactory()
// const e = await escrowFactory.getEscrowIdFromJob(0)
// console.log(e)
// const j = await escrowFactory.getEscrow(e)
// console.log(j)
</script>

<template>
  <div class="py-10">
    <!-- <template v-if="store.user?.isJudge">
      User is reviewer
    </template> -->
  </div>
</template>
