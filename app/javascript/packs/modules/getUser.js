import axios from 'axios'

// サーバーに問い合わせてユーザー情報を取得
export function getUser(id) {
  return new Promise((resolve, reject) => {
    if (!id) reject(new Error('not defined argument :id'))
    axios.get('/api/users/' + id)
      .then(res => {
        resolve(res.data.user)
      })
      .catch(err => {
        reject(err)
      })
  })
}
