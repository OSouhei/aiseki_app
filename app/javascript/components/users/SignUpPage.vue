<template>
  <div class="signup">
    <h2>アカウント登録</h2>
    <el-form ref="form" :model="user" label-position="right" label-width="150px">
      <el-form-item label="名前">
        <el-input v-model="user.name"></el-input>
      </el-form-item>
      <el-form-item label="メールアドレス">
        <el-input v-model="user.email"></el-input>
      </el-form-item>
      <el-form-item label="パスワード">
        <el-input v-model="user.password"></el-input>
      </el-form-item>
      <el-form-item label="パスワード（確認）">
        <el-input v-model="user.password_confirmation"></el-input>
      </el-form-item>
      <el-form-item>
        <el-button type="primary" @click="onSubmit">登録</el-button>
      </el-form-item>
    </el-form>
  </div>
</template>

<script>
export default {
  data() {
    return {
      user: {
        name: '',
        email: '',
        password: '',
        password_confirmation: '',
      }
    }
  },
  methods: {
    onSubmit() {
      // submit時の処理
    }
  }
}
</script>

<style scoped>
h2 {
  text-align: center;
  margin-left: 40px;
  margin-bottom: 60px;
}
.signup {
  margin-top: 80px;
}

.el-form {
  width: 600px;
  margin: 30px auto;
}

.el-form-item {
  margin-bottom: 45px;
}

.el-button--primary {
  margin-left: 150px;
}
</style>