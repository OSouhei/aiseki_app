<template>
  <div class="signup">
    <h2>アカウント登録</h2>
    <el-form ref="form" :model="user" :rules="rules" label-position="right" label-width="150px">
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
        <el-button type="primary" @click="onSubmit">登録</el-button>
      </el-form-item>
    </el-form>
  </div>
</template>

<script>
export default {
  data() {
    // メールアドレスのカスタムバリデーション関数
    var validateEmail = (rule, value, callback) => {
      const validEmailRegex = /^[A-Za-z0-9]{1}[A-Za-z0-9_.-]*@{1}[A-Za-z0-9_.-]{1,}\.[A-Za-z0-9]{1,}$/
      if(value === '') {
        callback(new Error('メールアドレスを入力して下さい'))
      // メールアドレスが正規表現にマッチする時
      } else if (validEmailRegex.test(value)) {
        callback()
      // メールアドレスが正規表現にマッチしない時
      } else {
        callback(new Error('正しい形式のメールアドレスを入力して下さい'))
      }
    }

    return {
      user: {
        name: '',
        email: '',
        password: '',
        password_confirmation: '',
      },
      // 検証ルール
      rules: {
        name: [
          { required: true, message: '名前を入力して下さい', trigger: 'blur' },
          { max: 50, message: '名前は５０文字以内にして下さい', trigger: 'blur' }
        ],
        email: [
          { required: true, message: 'メールアドレスを入力して下さい', trigger: 'blur' },
          { max: 255, message: 'メールアドレスは255文字以内にして下さい', trigger: 'blur' },
          { validator: validateEmail, trigger: 'blur' }
        ],
        password: [
          { required: true, message: 'パスワードを入力して下さい', trigger: 'blur' },
          { min: 6, message: 'パスワードは６文字以上にして下さい', trigger: 'blur' }
        ],
        password_confirmation: [
          { required: true, message: 'パスワードを入力して下さい', trigger: 'blur' },
          { min: 6, message: 'パスワードは６文字以上にして下さい', trigger: 'blur' }
        ]
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