/// <reference types="vite/client" />

interface ImportMetaEnv {
  readonly VITE_DEPLOYED_ADDRESS: string
  readonly VITE_ACCOUNT_ADDRESS: string
}

interface ImportMeta {
  readonly env: ImportMetaEnv
}
