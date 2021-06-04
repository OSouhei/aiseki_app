<template>
    <router-view></router-view>
</template>

<script>
import Vue from 'vue'
import VueRouter from 'vue-router'

import Home from './components/Home.vue'

// ルーティング
const routes = [
  // トップページ
  {
    path: '/',
    name: 'home',
    component: Home
  },
]

const router = new VueRouter({
  routes,
})

Vue.use(VueRouter)

export default {
  router
}
</script>

<style scoped>
p {
  font-size: 2em;
  text-align: center;
}
</style>
