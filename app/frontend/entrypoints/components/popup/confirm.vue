<template>
  <v-dialog v-model="dialog" :max-width="options.width" persistent :style="{ zIndex: options.zIndex }" @keydown.esc="cancel">
    <v-card >
      <v-toolbar :color="options.color" density="compact" flat>
        <v-toolbar-title class="white--text">{{ title }}</v-toolbar-title>
      </v-toolbar>

      <v-card-text v-show="!!content" class="pa-4">{{ content }}</v-card-text>
      <v-card-actions class="pt-0">
        <v-spacer></v-spacer>

        <v-btn color="grey" v-show="options.showCancel" text @click.native="cancel">取消</v-btn>
        <v-btn color="primary darken-1" text @click.native="agree">{{ options.confirmBtnText }}</v-btn>
      </v-card-actions>
    </v-card>

  </v-dialog>
</template>

<script>
/**
 * Vuetify Confirm Dialog component
 *
 * Insert component where you want to use it:
 * <confirm ref="confirm"></confirm>
 *
 * Call it:
 * this.$refs.confirm.open('Delete', 'Are you sure?', { color: 'red' }).then((confirm) => {})
 * Or use await:
 * if (await this.$refs.confirm.open('Delete', 'Are you sure?', { color: 'red' })) {
 *   // yes
 * }
 * else {
 *   // cancel
 * }
 *
 * Alternatively you can place it in main App component and access it globally via this.$root.$confirm
 * <template>
 *   <v-app>
 *     ...
 *     <confirm ref="confirm"></confirm>
 *   </v-app>
 * </template>
 *
 * mounted() {
 *   this.$root.$confirm = this.$refs.confirm.open
 * }
 */
import { useTheme } from 'vuetify'
export default {
  setup () {
    const theme = useTheme()
    return {
      theme
    }
  },
  data: () => ({
    dialog: false,
    resolve: null,
    reject: null,
    content: '是否继续?',
    title: '再次确认',
    options: { 
      color: 'info',
      width: 290,
      zIndex: 999999,
      showCancel: true,
      confirmBtnText: '确定'
    }
  }),
  computed: {
    themeDark() {
      return localStorage.local_themeDark
    }
  },
  mounted() {
    this.theme.global.name.value = localStorage.local_themeDark == 'true' ? 'dark' : 'light'
  },
  methods: {
    open(options) {
      this.dialog = true
      this.title = options.title
      this.content = options.content
      this.options = Object.assign(this.options, options)
      return new Promise((resolve, reject) => {
        this.resolve = resolve
        this.reject = reject
      })
    },
    agree() {
      this.resolve(true)
      this.dialog = false
    },
    cancel() {
      this.reject(false)
      this.dialog = false
    }
  }
}
</script>
