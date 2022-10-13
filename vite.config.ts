import { defineConfig } from 'vite'
import RubyPlugin from 'vite-plugin-ruby'
import VuePlugin from '@vitejs/plugin-vue'
import vuetify from 'vite-plugin-vuetify'
import path from "path"

const devPort = 3036;

export default defineConfig({
  plugins: [
    RubyPlugin(),
    VuePlugin(),
    vuetify({ autoImport: true })
  ],
  resolve: {
    alias: {
      "@": path.resolve(__dirname, "app/frontend/entrypoints"),
    },
  }
})
