<template>
  <div class="signup">
    <h2>アカウント登録</h2>
    <el-form ref="form" :model="user" :rules="rules" label-position="right" label-width="150px">
      <div v-if="errors.length != 0">
        <ul v-for="e in errors" :key="e">
          <li>
            <el-alert :title="e" type="error" center show-icon></el-alert>
          </li>
        </ul>
      </div>
      <el-form-item label="名前" prop="name">
        <el-input v-model="user.name"></el-input>
      </el-form-item>
      <el-form-item label="メールアドレス" prop="email">
        <el-input v-model="user.email"></el-input>
      </el-form-item>
      <el-form-item label="パスワード" prop="password">
        <el-input v-model="user.password" show-password></el-input>
      </el-form-item>
      <el-form-item label="パスワード（確認）" prop="password_confirmation">
        <el-input v-model="user.password_confirmation" show-password></el-input>
      </el-form-item>
      <el-form-item>
        <el-button type="primary" @click.prevent="createUser">登録</el-button>
      </el-form-item>
    </el-form>
  </div>
</template>

<script>
import axios from 'axios'
import { validateEmail } from '../../packs/modules/validate_email'

export default {
  data() {
    return {
      user: {
        name: '',
        email: '',
        password: '',
        password_confirmation: ''
      },
      // 検証ルール
      rules: {
        name: [
          { required: true, message: '名前を入力して下さい', trigger: 'blur' },
          { max: 50, message: '名前は５０文字以内にして下さい', trigger: 'blur' },
        ],
        email: [
          { required: true, message: 'メールアドレスを入力して下さい', trigger: 'blur' },
          { max: 255, message: 'メールアドレスは255文字以内にして下さい', trigger: 'blur' },
          { validator: validateEmail, trigger: 'blur' },
        ],
        password: [
          { required: true, message: 'パスワードを入力して下さい', trigger: 'blur' },
          { min: 6, message: 'パスワードは６文字以上にして下さい', trigger: 'blur' },
        ],
        password_confirmation: [
          { required: true, message: 'パスワードを入力して下さい', trigger: 'blur' },
          { min: 6, message: 'パスワードは６文字以上にして下さい', trigger: 'blur' },
          { validator: this.validatePasswordConfirmation, trigger: 'blur' },
        ]
      },
      // サーバー側で発生したエラー
      errors: '',
    }
  },
  methods: {
    // APIに問い合わせてユーザーを作成
    createUser() {
      axios.post('/users', { user: this.user })
        .then(response => {
          let user = response.data
          this.$store.dispatch('setCurrentUser', user) // ログイン中のユーザ（currentUser)を設定
          this.$store.dispatch('setFlashMessage', 'アカウント登録に成功しました') // flashメッセージを設定
          // ユーザの個別ページに遷移する
          this.$router.push({
            path: '/',
            params: { id: user.id }
          })
        })
        .catch(error => {
          console.error(error)
          if(error.response.data && error.response.data.errors) {
            this.errors = error.response.data.errors
          }
        })
    },
    // パスワード（確認）のバリデーション関数
    validatePasswordConfirmation(rule, value, callback) {
      // パスワード（確認）が入力したパスワードと一致するか
      if (value == this.user.password) {
        callback()
      } else {
        callback(new Error('パスワードと一致していません'))
      }
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