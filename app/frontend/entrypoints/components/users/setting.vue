<template>
  <div>
    <div v-for="(value, key, idx) in config" :key="idx">
      <div class="text-green-500 font-bold">{{ key }}</div>
      <v-switch v-if="key.startsWith('is_')" v-model="config[key]" :label="labels[key]" color="success" class="m-0"></v-switch>
      <v-text-field v-else class="mt-3" dense v-model="config[key]" :label="labels[key]" outlined></v-text-field>
    </div>

    <v-btn class="my-5 mr-4" color="pink" dark fixed bottom right fab small elevation="6" @click="putConfig()">
      <v-icon>mdi-content-save</v-icon>
    </v-btn>
  </div>
</template>

<script>
export default {
  data() {
    return {
      config: {},
      userItems: [],
      labels: {
        is_keep_pos_balance: '维持仓位平衡',
      }
    }
  },
  mounted() {
    this.getConfig()
    window.vvm = this
  },
  computed: {
    myConfig() {
      return JSON.parse(JSON.stringify(this.config))
    }
  },
  watch: {
    myConfig: {
      handler(v, oldV) {
        if (Object.keys(oldV).length) {
          console.info(v.cross_unify_mode, oldV.cross_unify_mode)
          if (v.cross_unify_mode === true && !oldV.cross_unify_mode) {
            this.config.cross_unify_mode = Date.now()
            return
          }
        }
      },
      deep: true
    }
  },
  methods: {
    getConfig() {
      this.$https.get(`setting`).then(res => {
        this.config = res.data.data
      })
    },
    putConfig() {
      this.$https.put('setting', { setting: this.config }).then(res => {
        this.$alert.success('已保存...')
      })
    }
  }
}
</script>

<style scoped>
</style>