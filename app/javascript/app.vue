<template>
  <div id="app">
    <Header></Header>
    <Flash></Flash>
    <router-view></router-view>
  </div>
</template>

<script>
import Vue from 'vue'
import VueRouter from 'vue-router'
import axios from 'axios'
import Header from './components/Header'
import Flash from './components/Flash'
import Home from './components/Home'

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
    path: '/sign_up',
    component: () => import('./components/users/SignUpPage'),
    meta: { title: 'アカウント登録' }
  },
  // ログインページ
  {
    path: '/log_in',
    component: () => import('./components/users/LogInPage'),
    meta: { title: 'ログイン' }
  }
]

const router = new VueRouter({
  routes
})

Vue.use(VueRouter)

export default {
  router,
  components: {
    Header,
    Flash
  },
  methods: {
    // ページのタイトルを返すメソッド
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
    // マウント時にページタイトルを設定
    this.setTitle(this.$route)
    // マウント時にストアのログイン中のユーザを設定
    axios.get('/api/logged_in')
      .then(response => {
        let user = response.data
        if (Object.keys(user).length !== 0) {
          this.$store.dispatch('setCurrentUser', user)
        } else {
          this.$store.dispatch('setCurrentUser', {})
        }
      })
      .catch(error => {
        console.log(error)
      })
  },
  watch: {
    // ページが遷移するたびにページタイトルを変更
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
