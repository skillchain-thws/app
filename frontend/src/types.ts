export interface Job {
  owner: string
  id: number
  title: string
  description: string
  price: number
  inProcess: boolean
  tags: string[]
}
