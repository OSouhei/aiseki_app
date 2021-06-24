const CsrfTokenPlugin = {}
export default CsrfTokenPlugin.install = (Vue, { axios }) => {
  // CSRFトークンを取得
  const csrf_token = document.querySelector('meta[name="csrf-token"]').getAttribute('content')
  // CSRFトークンをヘッダに設定
  axios.defaults.headers.common = {
    'X-Request-With': 'XMLHttpRequest',
    'X-CSRF-Token': csrf_token
  }

  Vue.axios = axios
  Object.defineProperties(Vue.prototype, {
    axios: {
      get() {
        return axios
      }
    }
  })
}

