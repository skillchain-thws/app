<script setup lang="ts">
import { EMPTY_ADDRESS } from '@/constants'
import { fetchRequestDetails } from '@/lib/fetch'
import type { Message, ReviewRequestDetail } from '@/types'
import { compareAddress, shortenAddr } from '@/utils'
import { MoveLeft, ThumbsDown, ThumbsUp } from 'lucide-vue-next'
import type { RouteLocationResolved } from 'vue-router/auto'

const route = useRoute()
const router = useRouter()

const store = useStore()
const committeeFactory = await store.getCommitteeFactory()

const id = computed(() => +(route as RouteLocationResolved<'/committees/[id]'>).params.id)
const details = ref<ReviewRequestDetail & { userName: string }>()
const voters = ref<{ address: string, userName: string, vote: number }[]>([])
const votedCount = computed(() => voters.value.filter(v => v.vote).length)
const messages = ref<Message[]>()

onMounted(async () => {
  const d = await fetchRequestDetails(id.value)
  if (d.requester === EMPTY_ADDRESS)
    router.push('/committees')
  const user = await fetchUser(d.requester)
  details.value = { ...d, userName: user.userName }

  fetchVoters()
})

async function fetchVoters() {
  const res = await committeeFactory.getCommitteeVotes(id.value)
  const memberAddresses = res[0]
  const memberVotes = res[1]
  const members = await Promise.all(memberAddresses.map(m => fetchUser(m)))
  voters.value = memberAddresses.map((address, i) => ({
    address,
    userName: members[i].userName,
    vote: Number(memberVotes[i]),
  }))

  messages.value = await fetchMessages(id.value)
}

async function handleVote(vote: boolean) {
  if (!details.value)
    return
  const res = await committeeFactory.voteReviewRequest(details.value.escrowId, vote)
  const receipt = await res.wait()
  if (receipt?.status === 1)
    fetchVoters()
}
</script>

<template>
  <div class="py-10 space-y-6">
    <div class="space-y-6">
      <div class="flex items-center justify-between">
        <span class="text-3xl font-light">details</span>
        <RouterLink to="/committees">
          <Button size="sm">
            <MoveLeft class="mr-2" /> Back
          </Button>
        </RouterLink>
      </div>

      <div v-if="details" class="grid grid-cols-12 gap-3">
        <div class="col-span-4">
          <div class="border rounded-md h-[300px] overflow-auto p-3">
            <div class="flex flex-col justify-center items-center">
              <div>
                <Avatar :size="60" :address="details.requester" />
              </div>
              <p class="mt-2">
                {{ details.userName }}
              </p>
              <p class="text-muted-foreground text-sm">
                {{ shortenAddr(details.requester) }}
              </p>
              <div>
                <JobPrice>{{ details.newAmount }}</JobPrice>
              </div>
              <p class="bg-secondary px-3 py-1 rounded-md mt-2">
                {{ details.reason }}
              </p>
            </div>
          </div>
        </div>

        <div class="col-span-8">
          <div class="border rounded-md bg-background">
            <ScrollArea class="grow p-3 h-[300px]">
              <div class="flex flex-col gap-2 h-full">
                <template
                  v-for="{ sender, timestamp, content } in messages" :key="timestamp"
                >
                  <ChatBox
                    :dir="compareAddress(sender, details.requester) ? 'left' : 'right'"
                  >
                    {{ content }}
                    <template #timestamp>
                      <p class="text-sm text-muted-foreground text-end pr-3 py-1">
                        {{ useDateFormat(timestamp, 'HH:mm DD.MM.YY').value }}
                      </p>
                    </template>
                  </ChatBox>
                </template>
              </div>
            </ScrollArea>
          </div>
        </div>
      </div>

      <div class="space-y-3">
        <div class="pr-5 flex items-center justify-between">
          <span class="text-3xl font-light">members</span>
          <span class="font-medium">voted: {{ votedCount }} / {{ voters.length }}</span>
        </div>

        <ul class="space-y-3">
          <li v-for="voter in voters" :key="voter.userName">
            <div class="py-3 px-4 rounded-md border flex items-center gap-6">
              <div>
                <Avatar :address="voter.address" :size="45" />
              </div>

              <div>
                <p>
                  {{ voter.userName }}
                </p>
                <p class="text-muted-foreground text-sm">
                  {{ voter.address }}
                </p>
              </div>

              <div class="ml-auto flex items-center gap-3">
                <Button
                  variant="secondary"
                  size="icon"
                  :disabled="voter.userName !== store.user.userName"
                  @click="handleVote(true)"
                >
                  <ThumbsUp :size="20" stroke-width="1.25" :class="{ 'stroke-highlight': voter.vote === 2 }" />
                </Button>

                <Button
                  variant="secondary"
                  size="icon"
                  :disabled="voter.userName !== store.user.userName"
                  @click="handleVote(false)"
                >
                  <ThumbsDown :size="20" stroke-width="1.25" :class="{ 'stroke-destructive': voter.vote === 1 }" />
                </Button>
                <!-- {{ MemberVote[voter.vote] }} -->
              </div>
            </div>
          </li>
        </ul>
      </div>
    </div>
  </div>
</template>
