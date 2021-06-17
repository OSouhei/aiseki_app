<template>
  <div id="flash">
    <el-alert v-show="flag" :title="message" type="success" effect="dark"></el-alert>
  </div>
</template>

<script>
import { mapState } from 'vuex'

export default {
  data() {
    return {
      flag: false
    }
  },
  computed: {
    ...mapState({
      message: state => state.flashMessage
    })
  },
  watch: {
    // flashメッセージが空になるなら非表示に、逆なら表示する
    message(to, from) {
      if (to === '') {
        this.flag = false
      } else {
        this.flag = true
      }
    }
  }
}
</script>

<style scoped>
div#flash {
  margin-top: 15px;
}
</style>