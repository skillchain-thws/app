<template>
  <Card class="group-hover:border-primary transition-colors">
    <CardHeader>
      <CardTitle>
        <div class="flex justify-between">
          <Skeleton class="h-4 w-[200px]" />
        </div>
      </CardTitle>
      <CardDescription class="pt-2 flex gap-2">
        <Skeleton class="h-4 w-[80px]" />
        <Skeleton class="h-4 w-[50px]" />
      </CardDescription>
    </CardHeader>
    <CardContent>
      <div class="flex gap-2 flex-wrap">
        <Skeleton class="h-4 w-[60%]" />
        <Skeleton class="h-4 w-[35%]" />
        <Skeleton class="h-4 w-[45%]" />
        <Skeleton class="h-4 w-[50%]" />
        <Skeleton class="h-4 w-[70%]" />
      </div>
    </CardContent>
    <CardFooter>
      <Skeleton class="h-4 w-[15%]" />
    </CardFooter>
  </Card>
</template>
