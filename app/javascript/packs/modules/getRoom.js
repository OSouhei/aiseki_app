import axios from 'axios'

export function getRoom(id) {
  return new Promise((resolve, reject) => {
    axios.get('/rooms/' + id)
      .then(res => {
        const room = res.data.result.room
        resolve(room)
      })
      .catch(err => {
        console.error(err)
        reject(err)
      })
  })
}