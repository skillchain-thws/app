<script setup lang="ts">
import { fetchEscrow, fetchRequest, fetchUser } from '@/lib/fetch'
import type { Escrow } from '@/types'
import { shortenAddr } from '@/utils'
import { Forward } from 'lucide-vue-next'

type CustomEscrow = Escrow & { buyerUsername: string, sellerUsername: string }

const store = useStore()
const escrows = shallowRef<CustomEscrow[]>([])
const escrowFactory = await store.getEscrowFactory()
const receiver = shallowRef({ address: '', username: '' })

async function fetch() {
  const _escrows: CustomEscrow[] = []

  for (const id of store.user.escrowIds) {
    const escrow = await fetchEscrow(id)
    if (!escrow)
      return

    const buyer = await fetchUser(escrow.buyer)
    const seller = await fetchUser(escrow.seller)
    _escrows.push({
      ...escrow,
      buyerUsername: buyer.userName,
      sellerUsername: seller.userName,
    })
  }

  escrows.value = _escrows
  console.log(_escrows[0])
  const request = await fetchRequest(0)
  console.log(request)

  if (_escrows.length) {
    receiver.value = {
      address: _escrows[0].seller,
      username: _escrows[0].sellerUsername,
    }
  }
}

onMounted(() => {
  fetch()
})

async function handleSendOffer() {
  await escrowFactory.sendRequest(0)
}

const message = ref('')
function handleSend() {
  console.log(message.value)
}
</script>

<template>
  <div class="py-10">
    <div class="grid grid-cols-3">
      <div class="col-span-1">
        <ScrollArea class="h-[800px] pr-5">
          <ul class="space-y-3">
            <li v-for="escrow in escrows" :key="escrow.escrowId" class="cursor-pointer" @click="receiver = { address: escrow.seller, username: escrow.sellerUsername }">
              <div class="border rounded-md px-2 py-4 hover:border-primary transition-colors" :class="{ 'border-primary': receiver.address === escrow.seller }">
                <div class="flex items-center">
                  <Avatar class="w-[20%]" :size="45" :address="escrow.seller" />
                  <div>
                    <div class="space-x-2">
                      <span class="font-medium">{{ escrow.sellerUsername }}</span>
                      <span class="text-muted-foreground">{{ shortenAddr(escrow.seller) }}</span>
                    </div>
                    <p>You: Lorem ipsum dolor sit amet.</p>
                  </div>
                </div>
              </div>
            </li>
          </ul>
        </ScrollArea>
      </div>
      <div class="col-span-2 flex flex-col border rounded-md">
        <div class="border-b flex items-center gap-3 px-3 py-3">
          <Avatar :address="receiver.address" :size="35" />
          <div class="space-x-2">
            <span class="font-medium">{{ receiver.username }}</span>
            <span class="text-muted-foreground tracking-wide">{{ receiver.address }}</span>
          </div>
        </div>
        <ScrollArea class="grow p-3 pt-5">
          <div class="flex flex-col gap-3 h-full">
            <ChatBox>
              {{ receiver.username }} hat accepted your job request. send an offer now.
            </ChatBox>

            <ChatBox>
              <Button @click="handleSendOffer">
                send
              </Button>
            </ChatBox>
          </div>
        </ScrollArea>

        <div class="mt-auto px-3 pb-4">
          <form class="flex items-center gap-3" @submit.prevent="handleSend">
            <div class="grow">
              <Input v-model="message" placeholder="type something here..." />
            </div>
            <Button size="icon">
              <Forward :size="20" />
            </Button>
          </form>
        </div>
      </div>
    </div>
  </div>
</template>
