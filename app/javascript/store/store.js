import Vue from "vue"
import Vuex from 'vuex'

Vue.use(Vuex)

export default new Vuex.Store({
  strict: true,
  state: {
    // flash
    flash: {
      message: '', // flashの文章
      type: 'success' // flashのタイプ（success, warning, error）
    },
    currentUser: {} // ログイン中のユーザ
  },
  getters: {
    getFlash(state) {
      return state.flash
    },
    // ユーザーがログインしているか？
    isLoggedIn(state) {
      return Object.keys(state.currentUser).length !== 0 ? true : false
    }
  },
  mutations: {
    // flashを設定
    setFlash(state, { message, type }) {
      state.flash.message = message
      state.flash.type = type
    },
    // ログイン中のユーザを設定
    setCurrentUser(state, user) {
      state.currentUser = user
    }
  },
  actions: {
    setFlash(context, flash) {
      context.commit('setFlash', flash)
    },
    setCurrentUser(context, user) {
      context.commit('setCurrentUser', user)
    }
  }
})
