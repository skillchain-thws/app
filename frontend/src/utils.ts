export function shortenAddr(addr: string) {
  const l = 4
  const length = addr.length
  return `${addr.substring(0, l + 2)}...${addr.substring(length - l, length)}`
}
