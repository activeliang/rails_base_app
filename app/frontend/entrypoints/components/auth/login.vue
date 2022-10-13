<template>
  <v-main>
    <v-container fluid fill-height>
      <v-layout align-center justify-center>
        <div class="w-full flex justify-center">
          <v-card class="elevation-12 w-96" @keyup.enter="handleLogin">
            <v-toolbar color="primary" dark flat>
              <v-toolbar-title>用户登录</v-toolbar-title>
              <v-spacer></v-spacer>

            </v-toolbar>
            <v-card-text>
              <v-form>
                <v-text-field clearable label="用户名" name="login" prepend-icon="mdi-account" type="text" v-model="inputName" :error="!!inputNameErrors.length" :error-messages="inputNameErrors"></v-text-field>
                <v-text-field clearable id="password" label="密码" name="password" prepend-icon="mdi-lock" type="password" v-model="inputPassword" :error="!!inputPasswordErrors.length" :error-messages="inputPasswordErrors"></v-text-field>
              </v-form>
            </v-card-text>
            <v-card-actions>
              <v-spacer></v-spacer>
              <v-btn @click="handleLogin" color="primary">登录</v-btn>
            </v-card-actions>
          </v-card>
        </div>
      </v-layout>
    </v-container>
  </v-main>
</template>

<script>
import { mapActions } from 'vuex'
export default {
  name: '',
  data() {
    return {
      inputName: '',
      inputPassword: '',
      inputNameErrors: '',
      inputPasswordErrors: ''
    }
  },
  mounted() {
    window.vm = this
  },
  methods: {
    ...mapActions(['login']),
    handleLogin() {
      this.login({ name: this.inputName, password: this.inputPassword }).then(access => {
        console.log('access: ', access)
        document.cookie = `jwt_access=${access}`
        let redirect = this.$route.query.redirect || '/'
        // this.$router.replace(redirect)
        location.href = redirect
      }).catch(err => {
        this.clearErrors()
        console.log('---> error code: ', err.response.status)
        if (err.response.status == 404) {
          this.inputNameErrors = err.response.data.name
        } else if (err.response.status == 422) {
          this.inputPasswordErrors = err.response.data.password
        } else if (err.response.status == 403) {
          this.inputNameErrors = err.response.data.name
        }
      })
    },
    clearErrors() {
      this.inputNameErrors = ''
      this.inputPasswordErrors = ''
    }
  }
}
</script>

<style lang="stylus" scoped></style>
