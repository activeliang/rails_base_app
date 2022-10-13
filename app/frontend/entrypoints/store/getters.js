// 设置object的默认值
const handler = {
  get: function(target, name) {
    return target.hasOwnProperty(name) ? target[name] : {}
  }
}

const getters =  {
  get: state => key => state[key],
  isLogin: state => state.access && state.refresh,
  isAdmin: state => {
    return state.access?.length && state.refresh?.length && state.userInfo.role === 'admin'
  }
}
export default getters
