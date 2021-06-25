import axios from 'axios'

export function getCurrentUser() {
  return new Promise((resolve, reject) => {
    axios.get('/api/login_user')
      .then(res => {
        const user = res.data
        resolve(user)
      })
      .catch(err => {
        console.error(err)
        reject(err)
      })
  })
}
