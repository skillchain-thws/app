import path from 'node:path'
import Vue from '@vitejs/plugin-vue'
import AutoImport from 'unplugin-auto-import/vite'
import Components from 'unplugin-vue-components/vite'
import { VueRouterAutoImports } from 'unplugin-vue-router'
import VueRouter from 'unplugin-vue-router/vite'
import { defineConfig } from 'vite'

export default defineConfig({
  resolve: {
    alias: {
      '@/': `${path.resolve(__dirname, 'src')}/`,
    },
  },
  plugins: [
    Vue({ script: { propsDestructure: true, defineModel: true } }),
    VueRouter(),
    AutoImport({
      imports: [
        'vue',
        '@vueuse/core',
        VueRouterAutoImports,
      ],
      dts: true,
      dirs: [
        './src/composables',
      ],
      vueTemplate: true,
    }),

    Components({
      dts: true,
    }),
  ],
})
