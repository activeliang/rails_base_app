import { createVuetify } from 'vuetify'
const vuetify = createVuetify() 
import { createApp } from 'vue'

import MessageConstructor from './confirm.vue'

var install = app => {
  var container = document.createElement('div');
  // createVNode 不行, 不能使用 use
  var instance = createApp(MessageConstructor, {})
      .use(vuetify) // vuetify 的组件貌似必须挂载在具有 symbol(vuetify) 的节点上...
      .mount(container);
  // 把虚拟节点加进 dom 树里(不要把 container 加进去)
  document.body.appendChild(container);
  app.config.globalProperties.$confirm = instance.open
};

export default { install }