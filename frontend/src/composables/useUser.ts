interface User {
  owner: string
  userName: string
  isJudge: boolean
  jobIds: number
  reviewsBuyerCount: number
  reviewSellerCount: number

}
export function useUser() {
  const user = shallowRef<User>()
  const store = useMMStore()
  const router = useRouter()

  store.getUserFactory().then((factory) => {
    factory.getUser(store.address).then((u) => {
      user.value = {
        owner: u[0],
        userName: u[1],
        isJudge: u[2],
        jobIds: Number(u[3]),
        reviewsBuyerCount: Number(u[4]),
        reviewSellerCount: Number(u[5]),
      }
    }).catch(() => {
      router.push('/error')
    })
  })

  return { user }
}
