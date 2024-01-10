<template>
  <ul class="space-y-5">
    <li v-for="i in 4" :key="i" class="px-5 py-3 border rounded-md grid grid-cols-11 gap-10">
      <div class="space-y-2 col-span-5">
        <Skeleton class="h-4 w-[300px]" />
        <Skeleton class="h-4 w-[500px]" />
        <Skeleton class="h-4 w-[400px]" />
      </div>

      <div class="space-y-2 col-span-5">
        <ul class="flex gap-2">
          <li><Skeleton class="h-4 w-[80px]" /></li>
          <li><Skeleton class="h-4 w-[130px]" /></li>
          <li><Skeleton class="h-4 w-[120px]" /></li>
        </ul>

        <Skeleton class="h-4 w-[100px]" />
      </div>
    </li>
  </ul>
</template>
