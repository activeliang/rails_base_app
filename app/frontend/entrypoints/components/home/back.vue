<template>
  <div>back</div>
  <v-btn @click="test">禾t</v-btn>
  {{ access }}
</template>

<script>
import { mapState } from 'vuex'

export default {
  computed: {
    ...mapState(['access'])
  },
  methods: {
    test() {
      console.info('kkkkk')
      this.$store.commit('save', { 'access': '88888888' })
    }
  }
}
</script>

<style scoped>

</style>