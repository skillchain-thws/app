<script setup lang="ts">
import { Egg } from 'lucide-vue-next'
</script>

<template>
  <header class="-mx-8">
    <nav class="px-8 grid grid-cols-4 items-center border-b">
      <div class="grid grid-cols-4 items-center col-span-2">
        <RouterLink to="/" class="flex items-center gap-2 col-span-2">
          <Egg :size="26" class=" fill-white" />
          <span class="text-2xl tracking-wide">freelancer</span>
        </RouterLink>

        <ul class="flex items-center gap-5 col-span-2 justify-between text-lg h-[100px]">
          <RouterLink to="/find" class="grow flex-center h-full border-b border-transparent hover:border-white transition-[border]" active-class="border-white">
            find job
          </RouterLink>
          <RouterLink to="/hiring" class="grow flex-center h-full border-b border-transparent hover:border-white transition-[border]" active-class="border-white">
            hiring
          </RouterLink>
          <RouterLink to="/chat" class="grow flex-center h-full border-b border-transparent hover:border-white transition-[border]" active-class="border-white">
            chat
          </RouterLink>
          <RouterLink to="/faq" class="grow flex-center h-full border-b border-transparent hover:border-white transition-[border]" active-class="border-white">
            faq
          </RouterLink>
        </ul>
      </div>

      <div class="col-span-2 flex justify-end items-center gap-x-5">
        <Avatar class="w-11 h-11">
          <AvatarImage src="avatar.png" alt="avatar" />
          <AvatarFallback>Avatar</AvatarFallback>
        </Avatar>
      </div>
    </nav>
  </header>
</template>
