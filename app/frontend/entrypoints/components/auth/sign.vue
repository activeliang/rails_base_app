<template>
<v-main>
  <v-container fluid fill-height>
    <v-layout align-center justify-center>
      <v-flex xs12 sm8 md4>
        <v-card class="elevation-12 w-full">
          <v-toolbar color="primary" dark flat>
            <v-toolbar-title>用户注册</v-toolbar-title>
            <v-spacer></v-spacer>
          </v-toolbar>
          <v-card-text>
            <v-form>
              <v-text-field clearable label="用户名" prepend-icon="mdi-account" type="text" v-model="phone.value" :error="!!phone.error.length" :error-messages="phone.error"></v-text-field>
              <v-text-field clearable label="密码" prepend-icon="mdi-lock" type="password" v-model="password.value" :error="!!password.error.length" :error-messages="password.error"></v-text-field>
              <v-text-field clearable label="密码确认" name="password" prepend-icon="mdi-lock" type="password" v-model="password_confirmation.value" :error="!!password_confirmation.error.length" :error-messages="password_confirmation.error"></v-text-field>
              <v-text-field clearable label="邀请码(选填)" name="invite" prepend-icon="mdi-lightbulb-on-outline" type="text" v-model="invite.value" :error="!!invite.error.length" :error-messages="invite.error" :disabled="invite.disabled"></v-text-field>
            </v-form>
          </v-card-text>
          <v-card-actions>
            <v-spacer></v-spacer>
            <v-btn @click="handleSign" color="primary">注册</v-btn>
          </v-card-actions>
        </v-card>
      </v-flex>
    </v-layout>
  </v-container>
</v-main>
</template>

<script>
export default {
  data() {
    return {
      drawer: null,
      source: {},
      phone: {
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
      },
      invite: {
        value: '',
        error: '',
        disabled: false
      },
      snackbar: false,
      snackbarText: ''
    }
  },
  mounted() {
    window.vm = this
    this.checkInviteCode()
  },
  methods: {
    handleSign() {
      this.$https.post('users', {
        phone: this.phone.value,
        password: this.password.value,
        password_confirmation: this.password_confirmation.value,
        invite: this.invite.value
      }).then(res => {
        console.log(res.data)
        this.$confirm("已完成注册，可以去手机APP登录了")
      }).catch(res => {
        console.log('===> sign error: ', res.response.data)
        const err = res.response.data
        for (const [k,v] of Object.entries(err)) {
          console.log('k,v', k, v)
          this.$set(this[k], 'error', v.join(','))
        }
      })
    },
    checkInviteCode() {
      setTimeout(_ => {
        if (this.$route.query.i) {
          this.$set(this.invite, 'value', this.$route.query.i)
          this.$set(this.invite, 'disable', true)
          this.alert('恭喜 您找到了一枚邀请码 已自动填入')
        }
      }, 500)
    },
  }
}
</script>

<style lang="stylus" scoped>

</style>
