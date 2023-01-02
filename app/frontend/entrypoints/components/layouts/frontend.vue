<template>
  <v-app id="inspire">
    <v-navigation-drawer v-model="drawer">
      <!--  -->
    </v-navigation-drawer>

    <v-app-bar>
      <v-app-bar-nav-icon @click="drawer = !drawer"></v-app-bar-nav-icon>
      <v-toolbar-title>Application</v-toolbar-title>
      <v-spacer></v-spacer>
      <v-btn icon @click="login">
        <v-icon>mdi-login</v-icon>
      </v-btn>
      <v-btn icon @click="toggleTheme">
        <v-icon>mdi-weather-night</v-icon>
      </v-btn>
    </v-app-bar>

    <v-main>
      <v-container fluid>
        <router-view></router-view>
      </v-container>
    </v-main>
  </v-app>
</template>

<script>
import { useTheme } from 'vuetify'
export default {
  setup () {
    const theme = useTheme()
    return {
      theme
    }
  },
  data: () => ({
    cards: ['Today', 'Yesterday'],
    drawer: false,
    links: [
      ['mdi-inbox-arrow-down', 'Inbox'],
      ['mdi-send', 'Send'],
      ['mdi-delete', 'Trash'],
      ['mdi-alert-octagon', 'Spam'],
    ],
  }),
  mounted() {
    this.initThemeDark()
    window.vv = this
  },
  methods: {
    initThemeDark() {
      this.theme.global.name.value = this.$store.state.themeDark ? 'dark' : 'light'
    },
    toggleTheme() {
      this.$store.commit('save', { themeDark: !this.theme.global.current.value.dark })
      if (this.theme.global.current.value.dark) {
        document.documentElement.classList.remove('dark')
        this.theme.global.name.value = 'light'
      } else {
        document.documentElement.classList.add('dark')
        this.theme.global.name.value = 'dark'
      }
    },
    login() {
      this.$router.push('/users')
    }
  }
}
</script>