<template>
  <div id="flash">
    <el-alert v-show="flag" :title="flashMessage" type="success" effect="dark" :closable="false"></el-alert>
  </div>
</template>

<script>
export default {
  data() {
    return {
      flag: false
    }
  },
  computed: {
    flashMessage() {
      return this.$store.getters.getFlashMessage
    }
  },
  watch: {
    // flashが更新されたら表示、3000ミリ秒後に非表示に
    flashMessage(val, old) {
      this.flag = true
      setTimeout(() => {
        this.flag = false
      }, 3000)
    }
  }
}
</script>

<style scoped>
div#flash {
  margin-top: 15px;
}
</style>