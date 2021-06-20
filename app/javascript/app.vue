<template>
  <div id="app">
    <Header></Header>
    <Flash></Flash>
    <router-view></router-view>
  </div>
</template>

<script>
import axios from 'axios'
import router from './router'
import Header from './components/Header'
import Flash from './components/Flash'

export default {
  components: {
    Header,
    Flash
  },
  methods: {
    // ページのタイトルを返すメソッド
    setTitle(routeInstance) {
      const baseTitle = '相席アプリ'
      let pageTitle = routeInstance.meta.title
      if (routeInstance.meta.title) {
        document.title = pageTitle + ' | ' + baseTitle
      } else {
        document.title = baseTitle
      }
    }
  },
  mounted() {
    // マウント時にストアのログイン中のユーザを設定
    axios.get('/api/logged_in')
      .then(res => {
        const user = res.data
        if (Object.keys(user).length !== 0) {
          this.$store.dispatch('setCurrentUser', user)
        } else {
          this.$store.dispatch('setCurrentUser', {})
        }
      })
      .catch(err => {
        console.log(err)
      })
  },
  watch: {
    // ページが遷移するたびにページタイトルを変更
    '$route'(to, from) {
    }
  }
}
</script>

<style scoped>
p {
  font-size: 2em;
  text-align: center;
}
</style>
