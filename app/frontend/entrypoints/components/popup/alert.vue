<template>
  <Transition @after-leave="onClose" enter-active-class="animate__animated animate__fadeInUp" leave-active-class="animate__animated animate__fadeOutUp">
    <div :id="id" class="message" closable :style="{ top: top + 'px', width: 'fit-content', margin: '0 auto' }" v-show="visibled">
      <v-alert class="alert" closable :type="type" @update:modelValue="handleInput" max-width="900" variant="flat" v-show="visibled">
        {{ message }}
      </v-alert>
    </div>
  </Transition>
</template>

<script >
import { onMounted, ref } from 'vue'
import { useTimeoutFn } from '@vueuse/core'
import 'animate.css'

export default {
  name: 'message',
  props: {
    id: String,
    type: {
      validator: function (value) {
        return ['success', 'warning', 'error', 'info'].includes(value);
      },
      default: 'info',
      type: String,
    },
    top: {
      type: Number,
      default: 56,
    },
    message: {
      type: String,
      default: '',
    },
    duration: {
      type: Number,
      default: 3000,
    },
    onClose: {
      type: Function,
      default: function () { },
    },
  },
  setup: function (props) {
    var visibled = ref(false);
    var stopTimer = undefined;
    // 开启定时器
    var startTimer = function () {
      if (props.duration > 0) {
        stopTimer = useTimeoutFn(function () {
          if (visibled.value) {
            close(); // 取消展示
          }
        }, props.duration)
      }
    };
    var clearTimer = function () {
      stopTimer === null || stopTimer === 0 ? 0 : stopTimer.stop()
    }
    // 为了重新开始计时
    var reTime = function () {
      // clearTimer();
      startTimer();
    };
    var close = function () {
      visibled.value = false;
    };
    onMounted(function () {
      startTimer();
      visibled.value = true;
    });
    return {
      visibled: visibled,
      close: close,
      reTime: reTime,
    };
  },
  methods: {
    handleInput() {
      this.onClose()
    }
  }
};
</script>

<style scoped >
.message {
  position: fixed;
  left: 0;
  right: 0;
  z-index: 9999;
  transition: top 0.6s linear;
}
.message .alert {
  margin: auto;
}
</style>