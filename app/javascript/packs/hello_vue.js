import Vue from 'vue'
import store from '../store/store'
import router from '../router'
import axios from 'axios'
import ElementUI from 'element-ui'
import 'element-ui/lib/theme-chalk/index.css'
import locale from 'element-ui/lib/locale/lang/ja'
import CsrfTokenPlugin from './plugins/csrf_token_plugin'
import App from '../app.vue'
import { getCurrentUser } from '../packs/modules/getCurrentUser'

Vue.use(ElementUI, { locale })
Vue.use(CsrfTokenPlugin, { axios })

document.addEventListener('DOMContentLoaded', async function() {
  try {
    // ログイン中のユーザーをストアに設定してから、他の処理は行う
    const currentUser = await getCurrentUser()
    if (Object.keys(currentUser).length !== 0) {
      store.dispatch('setCurrentUser', currentUser)
    } else {
      store.dispatch('setCurrentUser', {})
    }
  } catch(err) {
    console.error(err)
  }
  const app = new Vue({
    router,
    store,
    render: h => h(App)
  }).$mount()
  document.body.appendChild(app.$el)
  console.log(app)
})

