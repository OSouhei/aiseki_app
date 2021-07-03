<template>
  <div class="signup">
    <h2>ログイン</h2>
    <el-form ref="form" :model="user" :rules="rules" label-position="right" label-width="150px">
      <div v-if="errors.length != 0">
        <ul v-for="e in errors" :key="e">
          <li>
            <el-alert :title="e" type="error" center show-icon></el-alert>
          </li>
        </ul>
      </div>
      <el-form-item label="メールアドレス" prop="email">
        <el-input v-model="user.email" id="email"></el-input>
      </el-form-item>
      <el-form-item label="パスワード" prop="password">
        <el-input v-model="user.password" id="password" show-password></el-input>
      </el-form-item>
      <el-form-item>
        <el-button type="primary" @click.prevent="login" id="submit">ログイン</el-button>
      </el-form-item>
    </el-form>
  </div>
</template>

<script>
import axios from 'axios'
import { validateEmail } from '../../packs/modules/validateEmail'

export default {
  data() {
    return {
      user: {
        email: '',
        password: ''
      },
      // 検証ルール
      rules: {
        email: [
          { required: true, message: 'メールアドレスを入力して下さい', trigger: 'blur' },
          { max: 255, message: 'メールアドレスは255文字以内にして下さい', trigger: 'blur' },
          { validator: validateEmail, trigger: 'blur' },
        ],
        password: [
          { required: true, message: 'パスワードを入力して下さい', trigger: 'blur' },
          { min: 6, message: 'パスワードは６文字以上にして下さい', trigger: 'blur' },
        ]
      },
      // サーバー側で発生したエラー
      errors: []
    }
  },
  methods: {
    // APIに問い合わせてログインする
    login() {
      axios.post('/users/sign_in', { user: this.user })
        .then(res => {
          let user = res.data.result.user
          this.$store.dispatch('setCurrentUser', user) // ログイン中のユーザーを設定
          this.$store.dispatch('setFlash', { message: 'ログインしました', type: 'success' }) // flash
          this.$router.push({ path: '/' }).catch(err => {}) // トップページに移動
        })
        .catch(err => {
          console.error(err)
          this.$store.dispatch('setFlash', { message: 'ログインに失敗しました。メールアドレス、パスワードが正しいか確認して下さい', type: 'error' }) // flash
          if (err.response.data && err.response.data.errors) {
            this.errors = err.response.data.errors
          }
        })
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

li {
  list-style: none;
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