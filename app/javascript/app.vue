<template>
  <div id="app">
    <Header></Header>
    <Flash></Flash>
    <router-view></router-view>
  </div>
</template>

<script>
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
  created() {
    this.setTitle(this.$route)
  },
  watch: {
    // ページが遷移するたびにページタイトルを変更
    '$route'(to, from) {
      this.setTitle(to)
    },
    
  }
}
</script>

<style scoped>
p {
  font-size: 2em;
  text-align: center;
}
</style>
