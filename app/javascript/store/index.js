import Vue from "vue"
import Vuex from 'vuex'

Vue.use(Vuex)

export default new Vuex.Store({
  strict: true,
  state: {
    flashMessage: ''
  },
  mutations: {
    // flashメッセージを設定
    setFlashMessage(state, message) {
      state.flashMessage = message
    }
  },
  actions: {
    setFlashMessage(context, message) {
      context.commit('setFlashMessage', message)
    }
  }
})
