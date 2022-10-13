// To see this message, add the following to the `<head>` section in your
// views/layouts/application.html.erb
//
//    <%= vite_client_tag %>
//    <%= vite_javascript_tag 'application' %>
console.log('Vite ⚡️ Rails')

// If using a TypeScript entrypoint file:
//     <%= vite_typescript_tag 'application' %>
//
// If you want to use .jsx or .tsx, add the extension:
//     <%= vite_javascript_tag 'application.jsx' %>

console.log('Visit the guide for more information: ', 'https://vite-ruby.netlify.app/guide/rails')

// Example: Load Rails libraries in Vite.
//
// import * as Turbo from '@hotwired/turbo'
// Turbo.start()
//
// import ActiveStorage from '@rails/activestorage'
// ActiveStorage.start()
//
// // Import all channels.
// const channels = import.meta.globEager('./**/*_channel.js')

// Example: Import a stylesheet in app/frontend/index.css
// import '~/index.css'
import { createApp } from 'vue'
import App from './App.vue'
import '~/entrypoints/assets/styles.css'
import 'vuetify/styles'
import { createVuetify } from 'vuetify'
import router from './router'
import store from './store'

import { securedAxiosItem, plainAxiosItem } from '@/common/api'
import dayjs from 'dayjs' 

const app = createApp(App)
const vuetify = createVuetify() // Replaces new Vuetify()

app.config.globalProperties.$http = plainAxiosItem
app.config.globalProperties.$https = securedAxiosItem
app.config.globalProperties.$dayjs = dayjs

// import Confirm from '@/components/popup/confirm.js'
// app.config.globalProperties.$confirm = Confirm

// import Snackbar from '@/components/popup/snackbar.js'
// app.config.globalProperties.$snackbar = Snackbar

import Alert from '@/components/popup/alert.js'
Alert.install(app)

import Confirm from '@/components/popup/confirm.js'
Confirm.install(app)

app.config.globalProperties.$copy = text => navigator.clipboard.writeText(text)

app.use(vuetify)
app.use(router)
app.use(store)

app.mount('#app')



