import { defineConfig } from 'vite'
import RubyPlugin from 'vite-plugin-ruby'
import VuePlugin from '@vitejs/plugin-vue'
import vuetify from 'vite-plugin-vuetify'
import path from "path"
import viteCompression from 'vite-plugin-compression';

const devPort = 3036;

export default defineConfig({
  plugins: [
    RubyPlugin(),
    VuePlugin(),
    vuetify({ autoImport: true }),
    viteCompression({
      filter: /\.(js|json|mjs|css|html)$/i,
      ext: '.gz',
      algorithm: 'gzip'
    })
  ],
  resolve: {
    alias: {
      "@": path.resolve(__dirname, "app/frontend/entrypoints"),
    },
  },
  // css: {
  //   postcss: {
  //     plugins: [
  //       autoprefixer,
  //     ]
  //   }
  // },
  // build: {
  //   manifest: true,
  //   assetsDir: "vite",
  //   rollupOptions: {
  //     input: [
  //       "./app/frontend/entrypoints/application.js"
  //     ]
  //   }
  // }
})
