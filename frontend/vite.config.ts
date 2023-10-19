import vue from '@vitejs/plugin-vue'
import UnoCSS from 'unocss/vite'
import AutoImport from 'unplugin-auto-import/vite'
import Components from 'unplugin-vue-components/vite'
import { defineConfig } from 'vite'
import Pages from 'vite-plugin-pages'

export default defineConfig({
  plugins: [
    vue({ script: { propsDestructure: true, defineModel: true } }),
    Pages(),
    AutoImport({
      imports: ['vue', 'vue-router'],
      dts: true,
      dirs: ['./src/composables'],
      vueTemplate: true,
    }),
    Components({ dts: true }),
    UnoCSS(),
  ],

})
