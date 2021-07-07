<template>
  <div id="new-room">
    <h2>ルーム作成</h2>
    <el-form ref="form" :model="room" :rules="rules" label-position="right" label-width="150px">
      <!-- errors -->
      <div id="errors" v-if="errors.length !== 0">
        <ul v-for="e in errors" :key="e">
          <li>
            <el-alert :title="e" type="error" center show-icon></el-alert>
          </li>
        </ul>
      </div>
      <el-form-item label="タイトル" prop="title">
        <el-input v-model="room.title" id="title"></el-input>
      </el-form-item>
      <el-form-item label="メッセージ" prop="content">
        <el-input type="textarea" v-model="room.content" id="content"></el-input>
      </el-form-item>
      <el-form-item label="店名" prop="shop_name">
        <vue-simple-suggest v-model="room.shop_name" :list="getSuggestionList" display-attribute="name" value-attribute="name" @select="setShop">
          <el-input v-model="room.shop_name" id="shop_name"></el-input>
        </vue-simple-suggest>
      </el-form-item>
      <el-form-item label="人数制限" prop="limit">
        <el-input v-model="room.limit" id="limit"></el-input>
      </el-form-item>
      <el-form-item label="日付" prop="date">
        <Datetime v-model="room.date" type="datetime" @input="setDate" id="date"></Datetime>
      </el-form-item>
      <el-form-item>
        <el-button type="primary" @click.prevent="createRoom">ルーム作成</el-button>
      </el-form-item>
    </el-form>
  </div>
</template>

<script>
import axios from 'axios'
import VueSimpleSuggest from 'vue-simple-suggest'
import 'vue-simple-suggest/dist/styles.css'
import { Datetime } from 'vue-datetime'
import 'vue-datetime/dist/vue-datetime.css'
import { searchShop } from '../../packs/modules/searchShop'

export default {
  components: {
      VueSimpleSuggest,
      Datetime
    },
  data() {
    return {
      room: { title: '', content: '', shop_name: '', limit: '', date: '', shop_url: '' },
      errors: [],
      // 検証ルール
      rules: {
        title: [
          { required: true, message: 'ルーム名を入力して下さい', trigger: 'blur' },
          { max: 30, message: 'ルーム名は30文字以内にして下さい', trigger: 'blur' }
        ],
        content: [
          { max: 200, message: 'ルームメッセージは200文字以内にして下さい', trigger: 'blur' }
        ],
        shop_name: [
          { required: true, message: '店名を入力して下さい', trigger: 'blur' }
        ],
        limit: [
          { required: true, message: '人数を入力して下さい', trigger: 'blur' }
        ]
      }
    }
  },
  methods: {
    createRoom() {
      axios.post('/rooms', { room: this.room })
        .then(res => {
          const room = res.data.result.room
          this.$store.dispatch('setFlash', { message: 'ルームを作成しました', type: 'success' })
          this.$router.push('/') // 後で作成したルームページへ移動させる。。。
        })
        .catch(err => {
          console.error(err)
          if (err.response.data.result && err.response.data.result.errors) {
            this.errors = err.response.data.result.errors
          }
        })
    },
    // 店名サーチのサジェストを設定
    getSuggestionList: async function(keyword) {
      if (keyword.length === 0) return
      const shops = await searchShop(keyword)
      console.log(shops)
      return shops
    },
    // 店の名前と、URL（ホットペッパーグルメ）を設定
    setShop(shop) {
      this.room.shop_name = shop.name
      this.room.shop_url = shop.url
    },
    // 日付を設定
    setDate(time) {
      this.room.date = time
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

#new-room {
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