<template>
  <v-app id="inspire">
    <v-app-bar>
      <v-app-bar-nav-icon @click="drawer = !drawer"></v-app-bar-nav-icon>
      <v-toolbar-title>Application</v-toolbar-title>
      <v-spacer></v-spacer>
      <v-btn icon @click="toggleTheme">
        <v-icon>mdi-weather-night</v-icon>
      </v-btn>
      <div class="text-xl">{{ $store.state.userInfo && $store.state.userInfo.name }}</div>
      <v-btn icon @click="preLogout">
        <v-icon>mdi-logout</v-icon>
      </v-btn>
      <!-- <v-menu bottom offset-y>
        <template v-slot:activator="{ on }">
          <v-btn icon v-on="on">
            <v-icon>mdi-dots-vertical</v-icon>
          </v-btn>
        </template>

        <v-list>
          <v-list-item @click="changeMyPassword">
            <v-list-item-title>
              修改密码
            </v-list-item-title>
          </v-list-item>
          <v-list-item @click="preLogout">
            <v-list-item-title>
              退出
            </v-list-item-title>
          </v-list-item>
        </v-list>
      </v-menu> -->
    </v-app-bar>

    <v-navigation-drawer v-model="drawer">
      <v-list>
        <v-list-item v-for="[icon, text, to] in links" :key="icon" link :to="to">
          <template v-slot:prepend>
            <v-icon>{{ icon }}</v-icon>
          </template>
          <v-list-item-title>{{ text }}</v-list-item-title>
        </v-list-item>
      </v-list>
    </v-navigation-drawer>

    <v-main>
      <v-container fluid>
        <router-view></router-view>
      </v-container>
    </v-main>

    <v-dialog v-model="dialog" width="300" persistent>
      <v-card>
        <v-card-title class="headline green">
          修改我的登录密码
        </v-card-title>
        <v-card-text class="py-3">
          <v-form>
            <v-text-field clearable label="原密码" name="old_password" prepend-icon="mdi-lock" type="password" v-model="preEditItem.old_password.value" :error="!!preEditItem.old_password.error.length" :error-messages="preEditItem.old_password.error"></v-text-field>
            <v-text-field clearable label="新密码" name="password" prepend-icon="mdi-lock" type="password" v-model="preEditItem.password.value" :error="!!preEditItem.password.error.length" :error-messages="preEditItem.password.error"></v-text-field>
            <v-text-field clearable label="新密码确认" name="password_confirmationation" prepend-icon="mdi-lock" type="password" v-model="preEditItem.password_confirmation.value" :error="!!preEditItem.password_confirmation.error.length" :error-messages="preEditItem.password_confirmation.error"></v-text-field>
          </v-form>
        </v-card-text>
        <v-divider></v-divider>
        <v-card-actions>
          <v-spacer></v-spacer>
          <v-btn color="primary" text @click="dialog = false">关闭</v-btn>
          <v-btn @click="editItem" color="primary">提交修改</v-btn>
        </v-card-actions>
      </v-card>
    </v-dialog>

    <v-alert v-show="false"></v-alert>
    
  </v-app>
</template>

<script>
import { mapState, mapActions } from 'vuex'
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
    drawer: null,
    links: [
      ['mdi-inbox-arrow-down', 'Inbox'],
      ['mdi-send', 'Send'],
      ['mdi-delete', 'Trash'],
      ['mdi-alert-octagon', 'Spam'],
      ['mdi-account-multiple', '用户列表', '/users'],
      ['mdi-cog', '全局设置', '/setting'],
    ],
    preEditItem: {
      old_password: {
        value: '',
        error: ''
      },
      password: {
        value: '',
        error: ''
      },
      password_confirmation: {
        value: '',
        error: ''
      }
    },
    dialog: false
  }),
  mounted() {
    this.initThemeDark()
  },
  methods: {
    ...mapActions(['logout']),
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

    },
    changeMyPassword() {
      if (!this.$store.state.userInfo.id) {
        this.$snackbar.open('请先登录，或退出重新登录')
        return
      }
      this.dialog = true
    },
    preLogout() {
      this.$confirm({ content: '是否继续退出登录?', color: 'red' }).then(_ => {
        this.logout()
        this.$router.push('/')
      })
    },
  }
}
</script>