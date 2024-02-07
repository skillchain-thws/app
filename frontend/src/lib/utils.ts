import type { ClassValue } from 'clsx'
import { clsx } from 'clsx'
import { formatEther, parseEther } from 'ethers'
import { twMerge } from 'tailwind-merge'

export function cn(...inputs: ClassValue[]) {
  return twMerge(clsx(inputs))
}

export function toETH(v: number | bigint) {
  return Number.parseInt(formatEther(v))
}

export function toWEI(v: number | string) {
  return parseEther(v.toString())
}
