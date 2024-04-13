<template>
  <div>
    <!-- <v-data-table :headers="headers" :items="desserts" :items-per-page="5" class="elevation-1"></v-data-table> -->
    <v-table>
      <thead>
        <tr>
          <th class="text-left">#</th>
          <th class="text-left">Name</th>
          <th class="text-left">Role</th>
          <th class="text-left">Mark</th>
          <th class="text-left">is_freeze</th>
          <th class="text-left">Action</th>
        </tr>
      </thead>
      <tbody>
        <tr v-for="item in desserts" :key="item.name">
          <td>{{ item.id }}</td>
          <td>{{ item.name }}</td>
          <td>{{ item.role }}</td>
          <td>{{ item.mark }}</td>
          <td>{{ item.is_freeze }}</td>
          <td>
            <v-icon small class="mr-2" @click="preEdite(item)">mdi-pencil</v-icon>
            <v-icon small class="mr-2" @click="freezeItem(item)">mdi-account-lock-outline</v-icon>
          </td>
        </tr>
      </tbody>
    </v-table>
  </div>
</template>

<script>
export default {
  data() {
    return {
      headers: [
        { text: '#', value: 'id' },
        { text: 'name', value: 'name' },
        { text: 'role', value: 'role' },
        { text: 'mark', value: 'mark' },
        { text: 'is_freeze', value: 'is_freeze' },
      ],
      desserts: [],
    }
  },
  mounted() {
    this.getItems()
  },
  methods: {
    getItems() {
      this.$https.get(`users`).then(res => {
        console.info(res)
        this.desserts = res.data.data
      })
    },
    preEdite(item) {
      this.$set(this.preEditItem['id'], 'value', item.id)
      this.$set(this.preEditItem['name'], 'value', item.name)
      this.$set(this.preEditItem['password'], 'value', '')
      this.$set(this.preEditItem['mark'], 'value', item.mark)
      this.dialog = true
    },
    freezeItem(item) {
      this.$confirm('是否继续冻结用户？').then(_ => {
        this.$https.put(`users/${item.id}`, {
          is_freeze: true
        }).then(res => {
          this.getItems()
        }).catch(err => {
          console.log('freeze error: ', err.response.data)
        })
      })
    },
    createItem() {
      this.loading2 = true
      this.clearError(this.preEditItem)
      this.$https.post('users', {
        name: this.preEditItem.name.value,
        password: this.preEditItem.password.value,
        mark: this.preEditItem.mark.value
      }).then(res => {
        this.$snackbar.open('已新增', { color: 'green' })
        this.dialog2 = flase
      }).catch(err => {
        if (err.response.status == 422) {
          for (const [k, v] of Object.entries(err.response.data)) {
            this.$set(this.preEditItem[k], 'error', v)
          }
        }
        console.log('error: ', err.response)
      }).finally(_ => this.loading2 = false)
    }
  }
}
</script>

<style scoped>
</style>