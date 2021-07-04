<template>
  <div id="edit-user">
    <h2>プロフィール編集</h2>
    <el-form ref="form" :model="user" :rules="rules" label-position="right" label-width="150px">
      <!-- errors -->
      <div id="errors" v-if="errors.length !== 0">
        <ul v-for="e in errors" :key="e">
          <li>
            <el-alert :title="e" type="error" center show-icon></el-alert>
          </li>
        </ul>
      </div>
      <el-form-item label="名前" prop="name">
        <el-input v-model="user.name" id="name"></el-input>
      </el-form-item>
      <el-form-item label="メールアドレス" prop="email">
        <el-input v-model="user.email" id="email"></el-input>
      </el-form-item>
      <el-form-item label="変更するパスワード" prop="password">
        <el-input v-model="user.password" show-password id="password"></el-input>
      </el-form-item>
      <el-form-item label="パスワード（確認）" prop="password_confirmation">
        <el-input v-model="user.password_confirmation" show-password id="password-confirmation"></el-input>
      </el-form-item>
      <el-form-item label="現在のパスワード" prop="current_password">
        <el-input v-model="user.current_password" show-password id="current-password"></el-input>
      </el-form-item>
      <el-form-item>
        <el-button type="primary" @click.prevent="updateUser">編集</el-button>
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
        name: '',
        email: '',
        password: '',
        password_confirmation: '',
        current_password: ''
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
          { min: 6, message: 'パスワードは６文字以上にして下さい', trigger: 'blur' },
        ],
        password_confirmation: [
          { min: 6, message: 'パスワードは６文字以上にして下さい', trigger: 'blur' },
          { validator: this.validatePasswordConfirmation, trigger: 'blur' },
        ],
        current_password: [
          { required: true, message: '現在のパスワードを入力して下さい', trigger: 'blur' },
          { min: 6, message: 'パスワードは6文字以上です', trigger: 'blur' }
        ]
      },
      // サーバー側で発生したエラー
      errors: [],
    }
  },
  computed: {
    currentUser() {
      return this.$store.getters.getCurrentUser
    }
  },
  methods: {
    updateUser() {
      axios.patch('/users', { user: this.user })
        .then(res => {
          // ユーザーの編集に成功した場合
          const user = res.data.result.user
          this.$store.dispatch('setCurrentUser', user) // storeのcurrentUserを更新する
          this.$store.dispatch('setFlash', { message: 'ユーザー情報を編集しました', type: 'success' }) // flash
          this.$router.push({
            name: 'userPage',
            params: { id: user.id }
          })
        })
        .catch(err => {
          // ユーザー編集に失敗（エラーコードが返ってきた）場合
          console.error(err)
          if (err.response.data.result && err.response.data.result.errors) {
            this.errors = err.response.data.result.errors
          }
        })
    }
  },
  mounted() {
    // マウント時に現在のユーザーの情報をフォームに設定
    this.user.name = this.currentUser.name
    this.user.email = this.currentUser.email
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

.edit-user {
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