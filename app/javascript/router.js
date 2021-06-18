import Vue from 'vue'
import Router from 'vue-router'
import Home from './components/Home'

Vue.use(Router)

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

export default new Router({
  routes
})