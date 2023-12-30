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
  jobId: number
  buyer: string
  seller: string
  money: number
  started: boolean
  buyerAccepted: boolean
  sellerAccepted: boolean
}

export interface User {
  owner: string
  userName: string
  isJudge: boolean
  jobIds: number[]
  reviewsBuyerCount: number
  reviewSellerCount: number
}

declare global {
  interface Window {
    ethereum: Eip1193Provider
  }
}
