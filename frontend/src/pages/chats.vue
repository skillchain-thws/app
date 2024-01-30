<script setup lang="ts">
import { EMPTY_ADDRESS, EscrowRequestStatus } from '@/constants'
import { fetchEscrow, fetchJob, fetchMessages, fetchRequest, fetchRequestDetails, fetchUser } from '@/lib/fetch'
import type { Escrow, EscrowRequest, Job, Message, ReviewRequestDetail } from '@/types'
import { compareAddress, shortenAddr } from '@/utils'
import { CheckCircle2, Forward, HelpCircle, MessageCircleOff, MoreVertical, XCircle } from 'lucide-vue-next'

type CustomEscrow = Escrow & { buyerUsername: string, sellerUsername: string, job: Job }

const router = useRouter()
const route = useRoute()

const store = useStore()
const escrowFactory = await store.getEscrowFactory()
const chatFactory = await store.getChatFactory()
const committeeFactory = await store.getCommitteeFactory()

const escrowsAsBuyer = shallowRef<CustomEscrow[]>([])
const escrowsAsSeller = shallowRef<CustomEscrow[]>([])
const currentEscrow = ref<CustomEscrow>()
const currentRequest = ref<EscrowRequest>()
const isNoReceiver = computed(() =>
  (!escrowsAsBuyer.value.length && !escrowsAsSeller.value.length)
  || currentEscrow.value?.buyer === EMPTY_ADDRESS
  || currentEscrow.value?.seller === EMPTY_ADDRESS)
const messages = shallowRef<Message[]>([])
const role = ref<'buyer' | 'seller'>('buyer')
const s = ref('')
const reviewRequestDetails = shallowRef<ReviewRequestDetail & { username: string }>()

async function fetch() {
  const _escrowsAsBuyer: CustomEscrow[] = []
  const _escrowsAsSeller: CustomEscrow[] = []

  for (const id of store.user.escrowIds) {
    const e = await fetchEscrow(id)
    if (!e)
      return

    const buyer = await fetchUser(e.buyer)
    const seller = await fetchUser(e.seller)
    const job = await fetchJob(e.jobId)
    const escrow = {
      ...e,
      buyerUsername: buyer.userName,
      sellerUsername: seller.userName,
      job,
    }

    if (compareAddress(buyer.owner, store.address))
      _escrowsAsBuyer.push(escrow)
    else
      _escrowsAsSeller.push(escrow)
  }

  escrowsAsBuyer.value = _escrowsAsBuyer
  escrowsAsSeller.value = _escrowsAsSeller

  const queryId = route.query.id
  if (queryId) {
    const parsed = Number.parseInt(queryId.toString())

    const inBuyer = _escrowsAsBuyer.find(e => e.escrowId === parsed)
    if (inBuyer) {
      await handleChangeEscrow(inBuyer)
      return
    }
    const inSeller = _escrowsAsSeller.find(e => e.escrowId === parsed)
    if (inSeller) {
      await handleChangeEscrow(inSeller)
      return
    }
  }

  if (_escrowsAsBuyer.length)
    await handleChangeEscrow(_escrowsAsBuyer[0])
  else if (_escrowsAsSeller.length)
    await handleChangeEscrow(_escrowsAsSeller[0])
}

onMounted(fetch)

async function handleChangeEscrow(e: CustomEscrow) {
  if (currentEscrow.value?.escrowId === e.escrowId)
    return

  messages.value = []
  router.push(`/chats?id=${e.escrowId}`)
  role.value = e.buyerUsername === store.user.userName ? 'buyer' : 'seller'
  currentEscrow.value = e
  currentRequest.value = await fetchRequest(e.escrowId)
  messages.value = await fetchMessages(e.escrowId)

  const rrd = await fetchRequestDetails(e.escrowId)
  reviewRequestDetails.value
  = {
      ...rrd,
      username: compareAddress(e.buyer, rrd.requester) ? e.buyerUsername : e.sellerUsername,
    }
}

async function handleResponseFromBuyer() {
  if (!currentEscrow.value)
    return

  const res = await escrowFactory.sendRequest(currentEscrow.value.escrowId, { value: currentEscrow.value.price })
  const receipt = await res.wait()
  if (receipt?.status === 1) {
    if (!currentRequest.value)
      return
    currentRequest.value.status = EscrowRequestStatus.Pending
  }
}

async function handleResponseFromSeller(accepted: boolean) {
  if (!currentEscrow.value)
    return

  const response = await escrowFactory.respondToRequest(currentEscrow.value.escrowId, accepted)
  const receipt = await response.wait()
  if (receipt?.status === 1) {
    if (!currentRequest.value)
      return
    currentRequest.value.status = accepted ? EscrowRequestStatus.Accepted : EscrowRequestStatus.Declined
  }
}

const newMessage = ref('')
async function handleSend() {
  if (!currentEscrow.value || !newMessage.value)
    return

  const res = await chatFactory.sendMessage(currentEscrow.value.escrowId, newMessage.value)
  const receipt = await res.wait()
  if (receipt?.status === 1) {
    messages.value = await fetchMessages(currentEscrow.value.escrowId)
    newMessage.value = ''
  }
}

const isCommitteeDialogOpen = ref(false)
const newAmount = ref(0)
const reason = ref('')
const isReasonError = ref(false)

function handleOpenCommitteeDialog() {
  if (!currentEscrow.value)
    return

  isCommitteeDialogOpen.value = true
  newAmount.value = currentEscrow.value.price
}

async function handleOpenCommittee() {
  if (!currentEscrow.value)
    return

  isReasonError.value = false

  if (reason.value.length < 5) {
    isReasonError.value = true
    return
  }

  const response = await committeeFactory.openCommitteeReview(currentEscrow.value.escrowId, newAmount.value, reason.value)
  const receipt = await response.wait()
  if (receipt?.status === 1) {
    isCommitteeDialogOpen.value = false
    reason.value = ''
  }
}
</script>

<template>
  <div class="py-10">
    <div class="grid grid-cols-3 gap-5">
      <div class="col-span-1" :class="isNoReceiver ? 'border rounded-md' : 'border-none'">
        <BaseSearch v-if="!isNoReceiver" v-model="s" placeholder="search for chats" />

        <div v-if="!isNoReceiver" class="relative my-6">
          <Separator />
          <span class="absolute top-1/2 -translate-y-1/2 left-1/2 -translate-x-1/2 px-3 bg-background">
            to you
          </span>
        </div>

        <ScrollArea class="h-[600px]">
          <ul v-if="escrowsAsBuyer.length" class="space-y-3">
            <li
              v-for="e in escrowsAsBuyer"
              :key="e.escrowId"
              class="cursor-pointer"
              @click="handleChangeEscrow(e)"
            >
              <div
                class="border rounded-md px-4 py-3 hover:border-primary transition-colors"
                :class="{ 'border-primary': e.escrowId === currentEscrow?.escrowId }"
              >
                <div class="space-y-1">
                  <div class="flex items-center justify-between w-">
                    <p class="font-medium">
                      #{{ e.jobId }} {{ e.job.title }}
                    </p>
                    <JobPrice>
                      <template #parent>
                        <span class="font-normal mr-1">{{ e.job.price }}</span>
                      </template>
                    </JobPrice>
                  </div>

                  <div class="space-x-1">
                    <span>{{ e.sellerUsername }}</span>
                    <span class="text-muted-foreground">{{ shortenAddr(e.seller) }}</span>
                  </div>
                </div>
              </div>
            </li>
          </ul>

          <div v-if="!isNoReceiver" class="relative my-6">
            <Separator />
            <span class="absolute top-1/2 -translate-y-1/2 left-1/2 -translate-x-1/2 px-3 bg-background">from you</span>
          </div>

          <ul v-if="escrowsAsSeller.length" class="space-y-3">
            <li
              v-for="e in escrowsAsSeller"
              :key="e.escrowId"
              class="cursor-pointer"
              @click="handleChangeEscrow(e)"
            >
              <div class="border rounded-md px-4 py-3 hover:border-primary transition-colors" :class="{ 'border-primary': e.escrowId === currentEscrow?.escrowId }">
                <div class="space-y-1">
                  <div class="flex items-center justify-between w-">
                    <p class="font-medium">
                      #{{ e.jobId }} {{ e.job.title }}
                    </p>
                    <JobPrice>
                      <template #parent>
                        <span class="font-normal mr-1">{{ e.job.price }}</span>
                      </template>
                    </JobPrice>
                  </div>

                  <div class="space-x-1">
                    <span>{{ e.buyerUsername }}</span>
                    <span class="text-muted-foreground">{{ shortenAddr(e.buyer) }}</span>
                  </div>
                </div>
              </div>
            </li>
          </ul>

          <div v-if="isNoReceiver" class="pt-6 text-center">
            <p class="text-muted-foreground">
              there is no chat
            </p>
          </div>
        </ScrollArea>
      </div>

      <div class="col-span-2 flex flex-col border rounded-md">
        <div class="border-b flex items-center gap-3 p-3">
          <template v-if="role === 'buyer'">
            <Avatar :address=" currentEscrow?.seller" :size="35" />
            <div class="space-x-2">
              <span class="font-medium">{{ currentEscrow?.sellerUsername ?? 'n.a.' }}</span>
              <span class="text-muted-foreground">{{ currentEscrow?.seller ?? EMPTY_ADDRESS }}</span>
            </div>
          </template>
          <template v-else>
            <Avatar :address=" currentEscrow?.buyer" :size="35" />
            <div class="space-x-2">
              <span class="font-medium">{{ currentEscrow?.buyerUsername ?? 'n.a.' }}</span>
              <span class="text-muted-foreground">{{ currentEscrow?.buyer ?? EMPTY_ADDRESS }}</span>
            </div>
          </template>

          <div class="ml-auto">
            <DropdownMenu
              v-if="currentRequest?.status === EscrowRequestStatus.Pending && !compareAddress(reviewRequestDetails?.requester ?? '', store.address)"
            >
              <DropdownMenuTrigger>
                <Button variant="outline" size="icon" class="h-8 w-8">
                  <MoreVertical :size="20" />
                </Button>
              </DropdownMenuTrigger>

              <DropdownMenuContent align="end">
                <template v-if="role === 'seller'">
                  <DropdownMenuItem
                    class="text-highlight pr-4"
                    @click="handleResponseFromSeller(true)"
                  >
                    <div class="gap-2 flex items-center">
                      <CheckCircle2 :size="24" />
                      <span class="text-base">accept</span>
                    </div>
                  </DropdownMenuItem>

                  <DropdownMenuSeparator />

                  <DropdownMenuItem
                    class="text-destructive pr-4"
                    @click="handleResponseFromSeller(false)"
                  >
                    <div class="gap-2 flex items-center">
                      <XCircle :size="24" />
                      <span class="text-base">decline</span>
                    </div>
                  </DropdownMenuItem>

                  <DropdownMenuSeparator />
                </template>

                <DropdownMenuItem class="text-yellow-500 dark:text-yellow-400 pr-4" @click="handleOpenCommitteeDialog">
                  <div class="gap-2 flex items-center">
                    <HelpCircle :size="24" />
                    <span class="text-base">committee</span>
                  </div>
                </DropdownMenuItem>
              </DropdownMenuContent>
            </DropdownMenu>
          </div>
        </div>

        <div v-if="isNoReceiver" class="h-full flex-center">
          <MessageCircleOff
            :size="100"
            stroke-width="0.75"
            class="text-muted-foreground"
          />
        </div>

        <ScrollArea v-else class="grow p-3">
          <div class="flex flex-col gap-2 h-full">
            <template v-if="currentRequest?.status === EscrowRequestStatus.Pending && messages.length === 0">
              <p class="text-sm text-center text-muted-foreground">
                you both are now connected
              </p>
            </template>

            <template v-if="currentRequest?.status === EscrowRequestStatus.Start">
              <template v-if="role === 'buyer'">
                <ChatBox>
                  <BaseUsername>{{ currentEscrow?.sellerUsername ?? 'n.a.' }}</BaseUsername>
                  hat accepted your job buy request!
                </ChatBox>
                <ChatBox>
                  click this button to connect with them.
                </ChatBox>
                <ChatBox parent-class="">
                  <Button
                    size="sm"
                    @click="handleResponseFromBuyer"
                  >
                    connect
                  </Button>
                </ChatBox>
              </template>
              <template v-else>
                <ChatBox dir="right">
                  you hat already sent job request to <BaseUsername>{{ currentEscrow?.buyerUsername ?? 'n.a.' }}</BaseUsername>.
                </ChatBox>
                <ChatBox dir="right">
                  wait for them to accept!
                </ChatBox>
              </template>
            </template>

            <template
              v-for="{ sender, timestamp, content } in messages" :key="timestamp"
            >
              <ChatBox
                :dir="compareAddress(sender, store.address) ? 'right' : 'left'"
              >
                {{ content }}
                <template #timestamp>
                  <p class="text-sm text-muted-foreground text-end pr-3 py-1">
                    {{ useDateFormat(timestamp, 'HH:mm DD.MM.YY').value }}
                  </p>
                </template>
              </ChatBox>
            </template>

            <template v-if="currentRequest?.status === EscrowRequestStatus.Accepted && currentEscrow">
              <ChatReview :escrow-id="currentEscrow.escrowId" />
            </template>

            <template v-if="currentRequest?.status === EscrowRequestStatus.Declined">
              <p class="text-sm text-center text-muted-foreground">
                escrow has been canceled.
              </p>
            </template>

            <template v-if="currentEscrow && reviewRequestDetails?.requester !== EMPTY_ADDRESS">
              <p class="text-sm text-center text-muted-foreground">
                a committee has been requested by <BaseUsername>{{ reviewRequestDetails?.username }}</BaseUsername>
              </p>
            </template>
          </div>
        </ScrollArea>

        <div class="mt-auto p-3">
          <form class="flex items-center gap-3" @submit.prevent="handleSend">
            <div class="grow">
              <Input v-model="newMessage" placeholder="type something here..." />
            </div>
            <Button size="icon" :disabled="isNoReceiver || currentRequest?.status === EscrowRequestStatus.Accepted || currentRequest?.status === EscrowRequestStatus.Declined">
              <Forward :size="20" />
            </Button>
          </form>
        </div>
      </div>
    </div>
  </div>

  <Dialog v-model:open="isCommitteeDialogOpen">
    <DialogContent class="sm:max-w-[425px]">
      <DialogHeader>
        <DialogTitle>request committee</DialogTitle>
        <DialogDescription />
      </DialogHeader>

      <form class="space-y-3" @submit.prevent="handleOpenCommittee">
        <Label class="flex items-center gap-3">
          <span>amount</span>
          <Input v-model="newAmount" min="0" type="number" />
        </Label>

        <Textarea v-model="reason" placeholder="reason why you want to open a committee" />

        <p v-if="isReasonError" class="text-destructive">
          reason should have more than 5 characters
        </p>
        <Button class="w-full" type="submit">
          request
        </Button>
      </form>
    </DialogContent>
  </Dialog>
</template>
