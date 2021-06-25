<template>
  <div :id="'user-' + user.id">
    <p>id: {{ user.id }}</p>
    <p>name: {{ user.name }}</p>
    <p>email: {{ user.email }}</p>
  </div>
</template>

<script>
import { getUser } from '../../packs/modules/get_user'
import { BASE_TITLE } from '../../const'

export default {
  data() {
    return {
      user: {}
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
    }
  },
  created() {
    this.setUser(this.$route.params.id)
  },
  watch: {
    // ルートパラメータだけが変化してもデータを更新
    '$route'(to, from) {
      this.setUser(to.params.id)
    },
    user(val, old) {
      this.setTitle(val.name)
    }
  }
}
</script>