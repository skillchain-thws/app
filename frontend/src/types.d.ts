import type { Eip1193Provider } from 'ethers'

declare global{
  interface Window {
    ethereum: Eip1193Provider
  }
}

export interface Job {
  title: string
  badges: string[]
  description: string
  budget: number
}

export interface Profile {
  title: string
  badges: string[]
  description: string
  budget: number
  star: number
  ratingCount: number
}
