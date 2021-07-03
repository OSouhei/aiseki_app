<template>
  <div :id="'user-' + user.id">
    <p>id: {{ user.id }}</p>
    <p>name: {{ user.name }}</p>
    <p>email: {{ user.email }}</p>

    <router-link v-show="flag" :to="{ name: 'editUserPage' }">編集</router-link>
    <el-button v-show="flag" @click="signout" type="primary" class="button" round>退会</el-button>
  </div>
</template>

<script>
import axios from 'axios'
import { getUser } from '../../packs/modules/getUser'
import { BASE_TITLE } from '../../const'

export default {
  data() {
    return {
      user: {},
      flag: false
    }
  },
  computed: {
    currentUser() {
      return this.$store.getters.getCurrentUser
    }
  },
  methods: {
    // ユーザー情報を取得し、データに設定
    setUser(id) {
      getUser(id)
        .then(user => {
          this.user = user
        })
        .catch(err => {
          console.error(err)
          // 404 not found
          if (err.response.status === 404) {
            this.$store.dispatch('setFlash', { message: 'ユーザーを見つけることができませんでした', type: 'error' })
          // その他のエラー
          } else {
            this.$store.dispatch('setFlash', { message: '未知のエラー', type: 'error' })
          }
          this.$router.push('/')
        })
    },
    setTitle(title) {
      if(title) {
        document.title = title + ' | ' + BASE_TITLE
      } else {
        document.title = BASE_TITLE
      }
    },
    // 編集ページヘのリンクの表示・非表示
    setFlag() {
      // ログインしているユーザーとこのページのユーザーが同じ場合はユーザー編集ページへのリンクを表示
      if (JSON.stringify(this.currentUser) === JSON.stringify(this.user)) {
        this.flag = true
      // 同じでない場合はユーザー編集ページへのリンクを非表示
      } else {
        this.flag = false
      }
    },
    signout() {
      if (!window.confirm('本当に退会しますか？')) return // キャンセルを押した場合は、return
      axios.delete('/users')
        .then(res => {
          this.$store.dispatch('setFlash', { message: '退会しました', type: 'success' })
          this.$store.dispatch('setCurrentUser', {}) // 現在のユーザーを削除
          this.$router.push('/')
        })
        .catch(err => {
          console.error(err)
          this.$store.dispatch('setFlash', { message: '退会に失敗しました', type: 'error' })
        })
    }
  },
  created() {
    this.setUser(this.$route.params.id)
    this.setFlag()
  },
  watch: {
    // ルートパラメータだけが変化してもデータを更新
    '$route'(to, from) {
      this.setUser(to.params.id)
    },
    user(val, old) {
      this.setTitle(val.name)
      // このページのユーザーが存在する場合
      this.setFlag()
    }
  }
}
</script>