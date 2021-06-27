<template>
  <div :id="'user-' + user.id">
    <p>id: {{ user.id }}</p>
    <p>name: {{ user.name }}</p>
    <p>email: {{ user.email }}</p>

    <router-link v-show="flag" :to="{ name: 'editUserPage' }">編集</router-link>
  </div>
</template>

<script>
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
    setFlag() {
      console.log(JSON.stringify(this.currentUser))
      console.log(JSON.stringify(this.user))
      // ログインしているユーザーとこのページのユーザーが同じ場合はユーザー編集ページへのリンクを表示
      if (JSON.stringify(this.currentUser) === JSON.stringify(this.user)) {
        this.flag = true
      // 同じでない場合はユーザー編集ページへのリンクを非表示
      } else {
        this.flag = false
      }
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