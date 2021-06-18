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
            <router-link to="#">
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
import { mapGetters } from 'vuex';

export default {
  data() {
    return {
      activeIndex: '1',
      activeIndex2: '1'
    };
  },
  computed: mapGetters([ 'isLoggedIn' ]),
  methods: {
    // ログアウトする
    logout() {
      axios.delete('/users/sign_out')
        .then(response => {
          this.$store.dispatch('setCurrentUser', {}) // ログイン中のユーザーを空に
          this.$store.dispatch('setFlashMessage', 'ログアウトしました') // flash
          this.$router.push({ path: '/' }).catch(err => {}) // トップページに移動
        })
        .catch(error => {
          console.error(error)
          this.$store.dispatch('setFlashMessage', 'ログアウトに失敗しました') // flash
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