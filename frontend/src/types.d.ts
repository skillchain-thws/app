import type { Eip1193Provider } from 'ethers'

export interface Job {
  owner: string
  id: number
  title: string
  description: string
  price: number
  inProcess: boolean
  tags: string[]
}

export interface Escrow {
  escrowId: number
  jobId: number
  buyer: string
  seller: string
  money: number
  price: number
  started: boolean
  isDone: boolean
}

export interface User {
  owner: string
  userName: string
  isJudge: boolean
  jobIds: number[]
}

declare global {
  interface Window {
    ethereum: Eip1193Provider &
    { on(event: string, fn: () => void): void }
  }
}
