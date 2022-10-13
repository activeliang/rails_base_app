const mutations = {
  save(state, params) {
    for (const [k,v] of Object.entries(params)) {
      this.commit('setStateAndLocalStorage', { k, v })
    }
  },
  clear(state, keys) {
    let targets = (Array.isArray(keys)) ? keys : [keys]
    keys.forEach(i => {
      this.commit('removeStateAndLocalStorage', i)
    })
  },
  setStateAndLocalStorage(state, { k, v }) {
    state[k] = v
    try { localStorage[`local_${k}`] = JSON.stringify(v) } catch { console.log(`----> vuex store to local error `)}
  },
  removeStateAndLocalStorage(state, k) {
    state[k] = null
    try { delete localStorage[`local_${k}`] } catch { console.log(`----> vuex store to local error `)}
  },
}
export default mutations
