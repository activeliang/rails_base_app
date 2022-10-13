const defaultValueList = {
  access: '',
  refresh: '',
  userInfo: {},
  themeDark: true,
  recentOcr: []
}

const state = {}

for (const [k, v] of Object.entries(defaultValueList)) {
  try {
    state[k] = JSON.parse(localStorage[`local_${k}`])
  } catch (e) {
    state[k] = v
  }
}

export default () => state
