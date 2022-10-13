// src/router/index.js

import { createRouter, createWebHistory, createWebHashHistory } from 'vue-router'
import { defineAsyncComponent } from 'vue'
const modules = import.meta.glob('@/components/*/*.vue')

const router = createRouter({
  // history: createWebHashHistory(),  // hash 模式
  history: createWebHistory(),  // history 模式
  routes: [
    {
      path: '/',
      name: '',
      component: modules[`/entrypoints/components/layouts/frontend.vue`],
      children: [
        {
          path: '/',
          name: 'home',
          component: modules[`/entrypoints/components/home/index.vue`],
          meta: {
            title: '首页',
          },
        },
        {
          path: '/login',
          name: 'login',
          component: modules[`/entrypoints/components/auth/login.vue`],
          meta: {
            title: '登录',
          },
        }, {
          path: '/sign',
          name: 'sign',
          component: modules[`/entrypoints/components/auth/sign.vue`],
          meta: {
            title: '注册',
          },
        }
      ]
    },
    {
      path: '/(l)*',
      component: modules[`/entrypoints/components/layouts/backend.vue`],
      children: [{
        path: '/back',
        name: 'back',
        component: modules[`/entrypoints/components/home/back.vue`],
        meta: {
          title: '后台首页',
        },
      },{
        path: '/users',
        name: 'Users',
        component: modules[`/entrypoints/components/users/index.vue`],
        meta: {
          title: '后台首页',
        },
      }]
    },
    {
      path: '/*',
      redirect: '/',
    },
  ]
})

// 全局路由守卫
router.beforeEach((to, from, next) => {
  // console.log(to, from)
  if (to.meta.title) {
    document.title = `${to.meta.title}`;
  }
  next()
})

router.afterEach((to, from) => {
  // console.log(to, from)
  // console.log('afterEach')
})

export default router