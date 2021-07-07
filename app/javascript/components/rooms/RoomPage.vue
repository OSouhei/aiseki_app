<template>
  <div :id="'room-' + room.id">
    <p>title: {{ room.title }}</p>
    <p>content: {{ room.content }}</p>
    <p>url:
      <a :href="room.shop_url">{{ room.shop_name }}</a>
    </p>
    <p>limit: {{ room.limit }}</p>
    <p>owner:
      <router-link :to="'/users/' + room.owner_id">{{ room.owner_name }}</router-link>
    </p>
    <div v-show="isOwner">
      <router-link to="#">編集</router-link>
      <el-button type="primary" class="button" round>削除</el-button>
    </div>
  </div>
</template>

<script>
import { getRoom } from '../../packs/modules/getRoom'
import { BASE_TITLE } from '../../const'

export default {
  data() {
    return {
      room: ''
    }
  },
  computed: {
    currentUser() {
      return this.$store.getters.getCurrentUser
    },
    // このページのルームの作成主か？
    isOwner() {
      return this.room.owner_id === this.currentUser.id
    }
  },
  methods: {
    // ルームを探索し、設定
    setRoom(id) {
      getRoom(id)
        .then(room => {
          this.room = room
        })
        .catch(err => {
          console.error(err)
          // 404 not found
          if (err.response.status === 404) {
            this.$store.dispatch('setFlash', { message: 'ルームを見つけることができませんでした', type: 'error' })
          // その他のエラー
          } else {
            this.$store.dispatch('setFlash', { message: '未知のエラー', type: 'error' })
          }
          this.$router.push('/')
        })
    },
    setTitle(room) {
      document.title = room ? room.title + ' | ' + BASE_TITLE : BASE_TITLE
    }
  },
  created() {
    this.setRoom(this.$route.params.id)
    this.setTitle(this.room)
  },
  watch: {
    '$route'(to, from) {
      this.setTitle(this.room)
    },
    room(val, old) {
      this.setTitle(val)
    }
  }
}
</script>