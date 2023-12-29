<script setup lang="ts">
import type { User } from '@/types'

const q = ref('')
const qDebounced = refDebounced(q, 500)

const store = useMMStore()
const userFactory = await store.getUserFactory()
const users = shallowRef<User[]>([])
const showUsers = computed(() => {
  if (!qDebounced.value)
    return users.value

  return users.value.filter(u =>
    u.userName.toLowerCase().includes(qDebounced.value.toLowerCase()),
  )
})

async function fetch() {
  const addresses = await userFactory.getAllUserAddresses()
  users.value = (await Promise.all(addresses.map(a => userFactory.getUser(a)))).map(x => ({
    owner: x[0],
    userName: x[1],
    isJudge: x[2],
    jobIds: x[3].map(Number),
    reviewsBuyerCount: Number(x[4]),
    reviewSellerCount: Number(x[5]),
  }))
}
onMounted(() => {
  fetch()
})

async function handleUpdateReviewer(addr: string, v: boolean) {
  if (v)
    await userFactory.setJudge(addr)
  else
    await userFactory.unsetJudge(addr)
}
</script>

<template>
  <div>
    <div class="py-10">
      <BaseSearch v-model="q" placeholder="search for username or keyword" />
    </div>

    <div class="py-8 space-y-8">
      <h1 class="text-4xl">
        users
      </h1>

      <Table>
        <TableCaption>a list of all users</TableCaption>
        <TableHeader>
          <TableRow>
            <TableHead class="">
              reviewer
            </TableHead>
            <TableHead>username</TableHead>
            <TableHead>address</TableHead>
            <TableHead>jobs posted</TableHead>
            <TableHead>sellers reviewed</TableHead>
            <TableHead>buyers reviewed</TableHead>
          </TableRow>
        </TableHeader>
        <TableBody>
          <TableRow v-for="user in showUsers" :key="user.userName">
            <TableCell class="">
              <Checkbox :default-checked="user.isJudge" @update:checked="(v) => handleUpdateReviewer(user.owner, v)" />
            </TableCell>
            <TableCell class="font-medium">
              {{ user.userName }}
            </TableCell>
            <TableCell class="tracking-wider">
              {{ user.owner }}
            </TableCell>
            <TableCell>{{ user.jobIds.length }}</TableCell>
            <TableCell>{{ user.reviewSellerCount }}</TableCell>
            <TableCell>{{ user.reviewsBuyerCount }}</TableCell>
          </TableRow>
        </TableBody>
      </Table>
    </div>
  </div>
</template>
