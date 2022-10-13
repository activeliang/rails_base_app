import { securedAxiosItem } from '@/common/api'

const actions = {
  login({ commit, state }, params) {
    return new Promise((resolve, reject) => {
      securedAxiosItem.post('/login', params).then(res => {
        console.log(`----> teset res: `, JSON.stringify(res.data))
        commit('save', {
          access: res.data.data.access,
          refresh: res.data.data.refresh,
          userInfo: res.data.data.user_info
        })
        resolve(res.data.data.access)
      }).catch(err => {
        reject(err)
      })
  })
  },
  logout({ commit, state }) {
    commit('clear', ['access', 'refresh', 'userInfo'])
  },
  removeRecentOcr({ commit, state }, id) {
    const tIdx = state.recentOcr.findIndex(i => i == id)
    if (tIdx < 0) return 
    state.recentOcr.splice(tIdx, 1)
    commit('save', {
      recentOcr: state.recentOcr
    })
    securedAxiosItem.put(`delivery_notes/${id}`, { done: true })
  },
  pushRecentOcr({ commit, state }, ids) {
    if (ids.length == 0) return 
    state.recentOcr.push(...ids)
    commit('save', {
      recentOcr: state.recentOcr.filter((v,i,s) => s.indexOf(v) === i)
    })
  },
  resetRecentOcr({ commit, state }, ids) {
    commit('save', {
      recentOcr: ids
    })
  }
}
export default actions
