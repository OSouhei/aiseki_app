<template>
  <div id="app">
    <Header></Header>
    <Flash></Flash>
    <router-view></router-view>
  </div>
</template>

<script>
import axios from 'axios'
import Header from './components/Header'
import Flash from './components/Flash'
import { BASE_TITLE } from './const'

export default {
  components: {
    Header,
    Flash
  },
  methods: {
    // ページのタイトルを設定
    setTitle(routeInstance) {
      let pageTitle = routeInstance.meta.title
      if (routeInstance.meta.title) {
        document.title = pageTitle + ' | ' + BASE_TITLE
      } else {
        document.title = BASE_TITLE
      }
    }
  },
  mounted() {
    this.setTitle(this.$route)
    // マウント時にストアのログイン中のユーザを設定
    axios.get('/api/login_user')
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
      this.setTitle(to)
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
