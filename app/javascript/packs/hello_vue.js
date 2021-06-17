import Vue from 'vue'
import store from '../store/store'
import router from '../router'
import axios from 'axios'
import ElementUI from 'element-ui'
import 'element-ui/lib/theme-chalk/index.css'
import locale from 'element-ui/lib/locale/lang/ja'
import CsrfTokenPlugin from './plugins/csrf_token_plugin'
import App from '../app.vue'

Vue.use(ElementUI, { locale })
Vue.use(CsrfTokenPlugin, { axios })

document.addEventListener('DOMContentLoaded', () => {
  const app = new Vue({
    router,
    store,
    render: h => h(App)
  }).$mount()
  document.body.appendChild(app.$el)

  console.log(app)
})

