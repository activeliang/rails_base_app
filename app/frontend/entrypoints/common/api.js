import axios from 'axios'
import store from '@/store/index'
import router from '@/router/index'

const API_URL = `/api/v1`

const securedAxiosItem = axios.create({
  baseURL: API_URL,
  // withCredentials: true,
  headers: {
    'Content-Type': 'application/json'
  }
})

const plainAxiosItem = axios.create({
  baseURL: API_URL,
  // withCredentials: true,
  headers: {
    'Content-Type': 'application/json'
  }
})

securedAxiosItem.interceptors.request.use(config => {
  const method = config.method.toUpperCase()
  if (method !== 'OPTIONS') {
    config.headers = {
      ...config.headers,
      'Authorization': `Bearer ${store.getters.get('access')}`
    }
  }
  return config
})

const delay = milliseconds => new Promise((resolve, reject) => setTimeout(resolve, milliseconds))

securedAxiosItem.interceptors.response.use(null, error => {
  if (error.response && error.response.config && error.response.status === 401) {
    // If 401 by expired access cookie, we do a refresh request
    console.log('pre to refresh', error)
    return plainAxiosItem.post('/refresh', {}, {
      headers: {
        'X-Refresh-Token': store.getters.get('refresh')
      }
    }).then(async res => {
      console.log('刷新refresh, result: ', res)
      store.commit('save', {
        access: res.data.data.access,
        userInfo: res.data.data.user_info
      })
      if (res.data.data.refresh) {
        store.commit('save', {
          refresh: res.data.data.refresh
        })
      }
      document.cookie = `jwt_access=${res.data.data.access}`
      let retryConfig = error.response.config
      retryConfig.headers['Authorization'] = `Bearer ${store.getters.get('access')}`
      console.log('`Bearer ${res.data.data.access}`', `Bearer ${res.data.data.access}`)
      console.info(retryConfig)
      await delay(1000)
      return plainAxiosItem.request(retryConfig)
    }).catch(error => {
      console.log('刷新refresh失败, result: ', error)
      if (error.response.config.url.search('refresh') != '-1' && error.response.status == 401 || error.response.config.url.search('refresh') != '-1' && error.response.status == 404) {
        store.commit('clear', ['access', 'refresh', 'userInfo'])
        alert('登录信息已过期，即将跳转至登录页面...')
        router.push('/login')
        console.log('refresh_token expired!!!')
      }
      return Promise.reject(error)
    })
  } else {
    return Promise.reject(error)
  }
})

export {
  securedAxiosItem,
  plainAxiosItem
}
