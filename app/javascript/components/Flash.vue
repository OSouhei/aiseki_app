<template>
  <div id="flash">
    <el-alert v-show="flag" :title="flash.message" :type="flash.type" effect="dark" :closable="false"></el-alert>
  </div>
</template>

<script>
export default {
  data() {
    return {
      flag: false // flashの表示・非表示
    }
  },
  computed: {
    flash() {
      return this.$store.getters.getFlash
    }
  },
  watch: {
    // flashが更新されたら表示、3000ミリ秒後に非表示に
    'flash.message'(val, old) {
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