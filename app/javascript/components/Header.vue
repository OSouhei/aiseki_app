<template>
  <div id="header">
    <!-- ログイン中のヘッダ -->
    <template v-if="isLoggedIn">
      <el-menu :default-active="activeIndex" class="el-menu-demo" mode="horizontal">
        <el-menu-item index="1"><router-link to="/">ホーム</router-link></el-menu-item>
        <el-menu-item index="2">使い方</el-menu-item>
        <el-menu-item index="3">お知らせ</el-menu-item>
        <el-container>
          <el-menu-item index="4">
            <router-link :to="'/users/' + currentUser.id">
              <el-button type="primary" class="button">アカウント情報</el-button>
            </router-link>
          </el-menu-item>
          <el-menu-item index="5">
            <el-button @click="logout" type="primary" class="button" round>ログアウト</el-button>
          </el-menu-item>
        </el-container>
      </el-menu>
    </template>
    <!-- ログインしていないときのヘッダ -->
    <template v-else>
      <el-menu :default-active="activeIndex" class="el-menu-demo" mode="horizontal">
        <el-menu-item index="1"><router-link to="/">ホーム</router-link></el-menu-item>
        <el-menu-item index="2">使い方</el-menu-item>
        <el-menu-item index="3">お知らせ</el-menu-item>
        <el-container>
          <el-menu-item index="4">
            <router-link to="/log_in">
              <el-button type="primary" class="button">ログイン</el-button>
            </router-link>
          </el-menu-item>
          <el-menu-item index="5">
            <router-link to="/sign_up">
              <el-button type="primary" class="button" round>新規登録</el-button>
            </router-link>
          </el-menu-item>
        </el-container>
      </el-menu>
    </template>
  </div>
</template>

<script>
import axios from 'axios'

export default {
  data() {
    return {
      activeIndex: '1',
      activeIndex2: '1'
    };
  },
  computed: {
    isLoggedIn() {
      return this.$store.getters.isLoggedIn
    },
    currentUser() {
      return this.$store.getters.getCurrentUser
    }
  },
  methods: {
    // ログアウトする
    logout() {
      axios.delete('/users/sign_out')
        .then(res => {
          this.$store.dispatch('setCurrentUser', {}) // ログイン中のユーザーを空に
          this.$store.dispatch('setFlash', { message: 'ログアウトしました', type: 'success' }) // flash
          this.$router.push({ path: '/' }).catch(err => {}) // トップページに移動
        })
        .catch(err => {
          console.error(err)
          this.$store.dispatch('setFlash', { message: 'ログアウトに失敗しました', type: 'error' }) // flash
        })
    }
  }
}
</script>

<style scoped>
a {
  text-decoration: none;
}

.el-container {
  float: right;
}
</style>