import { EMPTY_ADDRESS } from '@/constants'
import type { Escrow, EscrowRequest, Job, Message, ReviewRequestDetail, User } from '@/types'

export async function fetchEscrow(id: number): Promise<Escrow | undefined> {
  const store = useStore()
  const factory = await store.getEscrowFactory()
  const escrow = await factory.getEscrow(id)
  const buyer = escrow[2]
  const seller = escrow[3]
  if (buyer === EMPTY_ADDRESS || seller === EMPTY_ADDRESS)
    return

  return {
    escrowId: Number(escrow[0]),
    jobId: Number(escrow[1]),
    buyer: escrow[2],
    seller: escrow[3],
    money: escrow[4],
    price: escrow[5],
    started: escrow[6],
    isDone: escrow[7],
  }
}

export async function fetchEscrows(): Promise<Escrow[]> {
  const store = useStore()
  const factory = await store.getEscrowFactory()
  const escrows = await factory.getAllEscrows()
  return escrows
    .filter(e => e.buyer !== EMPTY_ADDRESS && e.seller !== EMPTY_ADDRESS)
    .map(e => ({
      escrowId: Number(e[0]),
      jobId: Number(e[1]),
      buyer: e[2],
      seller: e[3],
      money: e[4],
      price: e[5],
      started: e[6],
      isDone: e[7],

    }))
}

export async function fetchUser(addr: string): Promise<User> {
  const store = useStore()
  const factory = await store.getUserFactory()
  const u = await factory.getUser(addr)
  return {
    owner: u[0],
    userName: u[1],
    isJudge: u[2],
    jobIds: u[3].map(Number),
    escrowIds: u[4].map(Number),
  }
}

export async function fetchAllJobs(): Promise<Job[]> {
  const store = useStore()
  const factory = await store.getJobFactory()
  const jobs = await factory.getAllJobs()
  return jobs.filter(x => x[0] !== EMPTY_ADDRESS).map(x => ({
    owner: x[0],
    id: Number(x[1]),
    title: x[2],
    description: x[3],
    price: x[4],
    inProcess: x[5],
    tags: x[6],
  }))
}

export async function fetchJob(id: number): Promise<Job> {
  const store = useStore()
  const factory = await store.getJobFactory()
  const j = await factory.getJob(id)
  return {
    owner: j[0],
    id: Number(j[1]),
    title: j[2],
    description: j[3],
    price: j[4],
    inProcess: j[5],
    tags: j[6],
  }
}

export async function fetchRequest(escrowId: number): Promise<EscrowRequest> {
  const store = useStore()
  const factory = await store.getEscrowFactory()
  const request = await factory.getCurrentRequest(escrowId)

  return {
    buyer: request[0],
    seller: request[1],
    status: Number(request[2]),
    isStartRequest: request[3],
  }
}

export async function fetchMessages(id: number): Promise<Message[]> {
  const store = useStore()
  const factory = await store.getChatFactory()
  const ms = await factory.getAllChannelMessages(id)
  return ms.map(m => ({
    sender: m[0],
    receiver: m[1],
    timestamp: Number(m[2]),
    content: m[3],
  }))
}

export async function fetchRequestDetails(escrowId: number): Promise<ReviewRequestDetail> {
  const store = useStore()
  const factory = await store.getCommitteeFactory()
  const r = await factory.getReviewRequestDetails(escrowId)
  return {
    requester: r[0],
    newAmount: Number([1]),
    reason: r[2],
    requiredCommitteeMembers: Number(r[3]),
    isClosed: r[4],
    status: Number(r[5]),
    escrowId: Number(r[6]),
  }
}
