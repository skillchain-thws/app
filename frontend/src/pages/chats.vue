<script setup lang="ts">
import { shortenAddr } from '@/utils'
import { Forward } from 'lucide-vue-next'

const list = [
  { address: '0xbDA5747bFD65F08deb54cb465eB87D40e51B197E', username: 'tester' },
  { address: '0xdF3e18d64BC6A983f673Ab319CCaE4f1a57C7097', username: 'tester' },
  { address: '0x1CBd3b2770909D4e10f157cABC84C7264073C9Ec', username: 'tester' },
  { address: '0xFABB0ac9d68B0B445fB7357272Ff202C5651694a', username: 'tester' },
  { address: '0x14dC79964da2C08b23698B3D3cc7Ca32193d9955', username: 'tester' },
  { address: '0xCBDE0ac9d68B0B445fB73asdfsFf202C56512342', username: 'tester' },
  { address: '0xGREE79964da2C08b23698B3D3cc7Ca3219xxbqwe', username: 'tester' },
  { address: '0x5gFD79964da2C08b23698B3D3cc7Ca3219xcvbxc', username: 'tester' },
]

const reciever = shallowRef(
  { address: '0xbDA5747bFD65F08deb54cb465eB87D40e51B197E', username: 'reciever' },
)

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
            <li v-for="{ address, username } in list" :key="address" class="cursor-pointer" @click="reciever = { address, username }">
              <div class="border rounded-md px-2 py-4 hover:border-primary transition-colors" :class="{ 'border-primary': reciever.address === address }">
                <div class="flex items-center">
                  <Avatar class="w-[20%]" :size="45" :address="address" />
                  <div>
                    <div class="space-x-2">
                      <span class="font-medium">{{ username }}</span>
                      <span class="text-muted-foreground">{{ shortenAddr(address) }}</span>
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
          <Avatar :address="reciever.address" :size="35" />
          <div class="space-x-2">
            <span class="font-medium">{{ reciever.username }}</span>
            <span class="text-muted-foreground tracking-wide">{{ reciever.address }}</span>
          </div>
        </div>
        <ScrollArea class="grow p-3 pt-5">
          <div class="flex flex-col gap-3 h-full">
            <ChatBox>
              Lorem ipsum dolor, sit amet consectetur adipisicing elit. Nulla, ratione.
            </ChatBox>
            <ChatBox dir="right">
              Lorem ipsum dolor sit amet consectetur adipisicing elit. Aliquam, dolorum!
            </ChatBox>
            <ChatBox>
              Lorem ipsum dolor sit amet.
            </ChatBox>
            <ChatBox>
              Lorem ipsum dolor sit amet consectetur adipisicing elit.
            </ChatBox>
            <ChatBox dir="right">
              Lorem ipsum dolor sit amet consectetur adipisicing elit. Inventore porro dicta amet rem quis a.
            </ChatBox>
            <ChatBox dir="right">
              lorem ipsum dolor sit amet.
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
