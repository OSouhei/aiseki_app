<template>
  <div id="header">
    <!-- ログインしていないときのヘッダ -->
    <el-menu :default-active="activeIndex" class="el-menu-demo" mode="horizontal">
      <el-menu-item index="1"><router-link to="/">ホーム</router-link></el-menu-item>
      <el-menu-item index="2">使い方</el-menu-item>
      <el-menu-item index="3">お知らせ</el-menu-item>
      <!-- ログイン＆新規登録ボタン -->
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
  </div>
</template>

<script>
export default {
  data() {
    return {
      activeIndex: '1',
      activeIndex2: '1'
    };
  },
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