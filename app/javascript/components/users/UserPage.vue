<template>
  <div :id="'user-' + user.id">
    <div class="user-info">
      <div class="background"></div>
      <div class="main">
        <div class="container">
          <div class="block"><el-avatar :size="90" src="https://cube.elemecdn.com/3/7c/3ea6beec64369c2642b92c6726f1epng.png" /></div>
          <div class="link" v-show="flag">
            <el-button type="primary" class="button" round><router-link :to="{ name: 'editUserPage', params: this.user.id }">編集</router-link></el-button>
            <el-button v-show="flag" @click="signout" type="primary" class="button" round>退会</el-button>
          </div>
        </div>
        <div class="content">
          <h2>{{ user.name }}</h2>
          <span>{{ this.user.created_at }}から利用しています。</span>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import axios from 'axios'
import { getUser } from '../../packs/modules/getUser'
import { BASE_TITLE } from '../../const'

export default {
  data() {
    return {
      user: {
        id: '',
        name: '',
        email: '',
        created_at: ''
      },
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
      this.flag = this.currentUser.id === this.user.id ? true : false
    },
    // 退会する
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

<style scoped>
h2 {
  margin-bottom: 0;
}

a {
  color: #fff;
  text-decoration: none;
}

span {
  font-size: 12px;
  color: #777;
}

.background {
  height: 120px;
  background-color: #eee;
}

.container {
  height: 50px;
}

.block {
  position: relative;
}

.el-avatar {
  position: absolute;
  top: -45px;
  left: 45px;
}

.link {
  float: right;
  margin-top: 5px;
  margin-right: 45px;
}

.content {
  padding-left: 60px;
  padding-right: 60px;
}
</style>