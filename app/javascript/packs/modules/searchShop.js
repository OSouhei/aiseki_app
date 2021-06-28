import axios from 'axios'

export function searchShop(keyword) {
  return new Promise((resolve, reject) => {
    axios.get('/rooms/search_shop', { params: { keyword }})
      .then(res => {
        resolve(res.data.shops)
      })
      .catch(err => {
        console.error(err.response)
        reject(err)
      })
  })
}
