<template>
  <div id="app">
    <Header></Header>
    <router-view></router-view>
  </div>
</template>

<script>
import Vue from 'vue'
import VueRouter from 'vue-router'
import Header from './components/Header'
import Home from './components/Home'

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
  router,
  components: {
    Header
  }
}
</script>

<style scoped>
p {
  font-size: 2em;
  text-align: center;
}
</style>
