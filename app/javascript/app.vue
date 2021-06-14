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
    component: Home,
    meta: { title: '' }
  },
  // ユーザー新規登録ページ
  {
    path: '/users/sign_up',
    component: SignUpPage,
    meta: { title: 'アカウント登録' }
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
  },
  methods: {
    setTitle(routeInstance) {
      const baseTitle = '相席アプリ'
      let pageTitle = routeInstance.meta.title
      if (routeInstance.meta.title) {
        document.title = pageTitle + ' | ' + baseTitle
      } else {
        document.title = baseTitle
      }
    }
  },
  mounted() {
    this.setTitle(this.$route)
  },
  watch: {
    '$route'(to, from) {
      this.setTitle(to)
    }
  }
}
</script>

<style scoped>
p {
  font-size: 2em;
  text-align: center;
}
</style>
