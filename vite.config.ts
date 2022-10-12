import { defineConfig } from 'vite'
import RubyPlugin from 'vite-plugin-ruby'
import VuePlugin from '@vitejs/plugin-vue'

const devPort = 3036;

export default defineConfig({
  plugins: [
    RubyPlugin(),
    VuePlugin(),
  ],
  logLevel: "info",
  server: {
    host: true,
    port: devPort,
    origin: `http://localhost:${devPort}`,
  },
})
