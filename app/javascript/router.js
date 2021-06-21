import Vue from 'vue'
import store from './store/store'
import Router from 'vue-router'
import Home from './components/Home'

Vue.use(Router)

// ルーティング
const routes = [
  // トップページ
  {
    path: '/',
    component: Home,
    meta: {
      title: '', // ページ固有のタイトル
      requiresAuth: null // 認証が必要か？
    }
  },
  // ユーザー新規登録ページ
  {
    path: '/sign_up',
    component: () => import('./components/users/SignUpPage'),
    meta: {
      title: 'アカウント登録',
      requiresAuth: false
    }
  },
  // ログインページ
  {
    path: '/log_in',
    component: () => import('./components/users/LogInPage'),
    meta: {
      title: 'ログイン',
      requiresAuth: false
    }
  }
]

const router = new Router({
  routes
})

// ナビゲーションガード
router.beforeEach((to, from, next) => {
  // 認証が必要なページで、ログインしていない場合
  if (to.meta.requiresAuth && !store.getters.isLoggedIn) {
    store.dispatch('setFlash', { message: 'このページにアクセスするにはログインする必要があります', type: 'warning' })
    next('/log_in')
  // 認証済みではアクセスできないページで、ログイン済みの場合
  } else if (to.meta.requiresAuth === false && store.getters.isLoggedIn) {
    store.dispatch('setFlash', { message: 'このページにはアクセスできません', type: 'warning' })
    next(false)
  // ログインしていても、してなくても大丈夫なページの場合
  } else {
    next()
  }
})

export default router
