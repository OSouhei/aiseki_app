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
import SignUpPage from './components/users/SignUpPage'

// ルーティング
const routes = [
  // トップページ
  {
    path: '/',
    component: Home
  },
  // ユーザー新規登録ページ
  {
    path: '/users/sign_up',
    component: SignUpPage
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
