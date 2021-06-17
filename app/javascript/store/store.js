import Vue from "vue"
import Vuex from 'vuex'

Vue.use(Vuex)

export default new Vuex.Store({
  strict: true,
  state: {
    flashMessage: '', // flashの文章
    currentUser: {} // ログイン中のユーザ
  },
  getters: {
    // ユーザーがログインしているか？
    isLoggedIn(state) {
      return Object.keys(state.currentUser).length !== 0 ? true : false
    }
  },
  mutations: {
    // flashメッセージを設定
    setFlashMessage(state, message) {
      state.flashMessage = message
    },
    // ログイン中のユーザを設定
    setCurrentUser(state, user) {
      state.currentUser = user
    }
  },
  actions: {
    setFlashMessage(context, message) {
      context.commit('setFlashMessage', message)
    },
    setCurrentUser(context, user) {
      context.commit('setCurrentUser', user)
    }
  }
})
