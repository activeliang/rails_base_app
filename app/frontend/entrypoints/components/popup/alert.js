import { createApp, render, getCurrentInstance } from 'vue'
import { createVuetify } from 'vuetify'
import '~/entrypoints/assets/styles.css'
import 'vuetify/styles'
const vuetify = createVuetify() 
import MessageConstructor from './alert.vue'

var instances = []; // 消息队列
var offset = 70; // 单个消息框偏移
var seed = 1;
var message = function (options) {
  if (typeof options === 'string') {
      options = {
          message: options,
      };
  }
  var id = "message_".concat(seed++);
  var container = document.createElement('div');
  // createVNode 不行, 不能使用 use
  var app = createApp(MessageConstructor, { id: id, top: (instances.length + 1) * offset, onClose: function () {
          render(null, container);
          close(id);
      }, ...options })
      .use(vuetify) // vuetify 的组件貌似必须挂载在具有 symbol(vuetify) 的节点上...
      .mount(container);
  instances.push(app);
  // 把虚拟节点加进 dom 树里(不要把 container 加进去)
  document.body.appendChild(container.firstElementChild);
};
['success', 'info', 'warning', 'error'].forEach(function (type) {
  message[type] = function (content, options) {
    return message({ type: type, message: content, ...options});
  };
});
// 消息关闭时的相关处理函数...
// 例如把其他消息的 top 缩小
function close(id) {
    console.info('start close ')
  var idx = instances.findIndex(function (app) { return id === app.id; });
  if (idx === -1)
      return;
  var app = instances[idx];
  // 如果没有找到虚拟节点就什么都不做
  if (!app)
      return;
  // 从 idx 位置开始删除一个节点
  console.info('del one first')
  instances.splice(idx, 1);
  var len = instances.length;
  if (len < 1)
      return; // 删除一个虚拟节点后消息队列内没有元素, 什么都不做了
  for (var i = idx; i < len; i++) {
      instances[i]['reTime'](); // 重新开始定时
      // style 的 top 是 ..px 的形式, 因此需要 parseInt 解析出数字
      var pos = Number.parseInt(instances[i].$el.style.top, 10) - offset;
      instances[i]['$el'].style.top = "".concat(pos, "px");
  }
}


// 消息提示框插件
export default {
  install(app) {
    app.config.globalProperties.$alert = message
  },
}