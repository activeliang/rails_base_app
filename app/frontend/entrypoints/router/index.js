// src/router/index.js

import { createRouter, createWebHistory, createWebHashHistory } from 'vue-router'
import { defineAsyncComponent } from 'vue'
const modules = import.meta.glob('@/components/*/*.vue')
import store from '@/store'

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
          requireAdmin: true
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

  if (to.meta.requireAdmin) { // 判断该路由是否需要登录权限
    if (store.getters.isAdmin) { // 通过vuex state获取当前的token是否存在
      next()
    } else {
      router.$confirm({ content: '暂无权限，请登录一个管理员账号' })
      next({
        path: '/login',
        query: {
          redirect: to.fullPath
        } // 将跳转的路由path作为参数，登录成功后跳转到该路由
      })
    }
  } else if (to.meta.requireLogin) { // 判断该路由是否需要登录权限
    if (store.getters.isLogin) { // 通过vuex state获取当前的token是否存在
      next()
    } else {
      // Confirm.open('提示', '请先登录', {
      //   color: 'red'
      // }).then((confirm) => {
      //   console.log('close')
      // })
      router.$confirm({ content: '请先登录' })
      next({
        path: '/login',
        query: {
          redirect: to.fullPath
        } // 将跳转的路由path作为参数，登录成功后跳转到该路由
      })
    }
  } else {
    next()
  }
})

router.afterEach((to, from) => {
  // console.log(to, from)
  // console.log('afterEach')
})

const _handle_fun = router.install 
router.install = app => {
  router.$confirm = app.config.globalProperties.$confirm
  return _handle_fun.call(router, app)
}

export default router