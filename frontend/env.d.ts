/// <reference types="vite/client" />

interface ImportMetaEnv {
  readonly VITE_DEPLOYED_ADDRESS: string
  readonly VITE_ACCOUNT_ADDRESS: string
  readonly VITE_ACCOUNT_KEY: string
}

interface ImportMeta {
  readonly env: ImportMetaEnv
}
