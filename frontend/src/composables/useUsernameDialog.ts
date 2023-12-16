import DialogCreateUsername from '@/components/DialogCreateUsername.vue'

export function useUsernameDialog() {
  const isOpen = ref(false)
  const Comp = computed(() => h(DialogCreateUsername, {
    'open': isOpen.value,
    'onUpdate:open': (v: boolean) => {
      isOpen.value = v
    },
  }))

  function open() {
    isOpen.value = true
  }

  return { open, Comp }
}
