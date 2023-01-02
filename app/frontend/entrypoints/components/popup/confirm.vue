<template>
  <v-dialog v-model="dialog" :max-width="width" persistent :style="{ zIndex: zIndex }" @keydown.esc="cancel">
    <v-card >
      <v-toolbar :color="type" density="compact" flat>
        <v-icon class="ml-2">mdi-exclamation-thick</v-icon>
        <v-toolbar-title class="ml-1 white--text">{{ title }}</v-toolbar-title>
      </v-toolbar>

      <v-card-text v-show="!!content" class="pa-4">{{ content }}</v-card-text>
      <v-card-actions class="pt-0">
        <v-spacer></v-spacer>

        <v-btn color="grey" v-show="showCancel" text @click.native="cancel">取消</v-btn>
        <v-btn color="primary darken-1" text @click.native="agree">{{ confirmBtnText }}</v-btn>
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
  props: {
    id: String,
    type: {
      validator: function (value) {
        return ['success', 'warning', 'error', 'info'].includes(value);
      },
      default: 'info',
      type: String,
    },
    width: {
      type: Number,
      default: 340,
    },
    zIndex: {
      type: Number,
      default: 999999,
    },
    content: {
      type: String,
      default: '是否继续操作？',
    },
    title: {
      type: String,
      default: '再次确认',
    },
    showCancel: {
      type: Boolean,
      default: true
    },
    confirmBtnText: {
      type: String,
      default: "确定"
    }
  },
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
  }),
  computed: {
    themeDark() {
      return localStorage.local_themeDark
    }
  },
  mounted() {
    this.theme.global.name.value = localStorage.local_themeDark == 'false' ? 'light' : 'dark'
  },
  methods: {
    open() {
      this.dialog = true
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
