<template>
  <div>
    <h1>{{ page }}</h1>
      <el-button type="primary">Primary</el-button>

  </div>
</template>

<script>
export default {
  data() {
    return {
      page: 'Home.vue'
    }
  }
}
</script>

<style scoped>
h1 {
  text-align: center;
}
</style>