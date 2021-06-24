// Elementのバリデーションルールで使用する関数を定義

// メールアドレスのバリデーション関数
export function validateEmail(rule, value, callback) {
  const validEmailRegex = /^[A-Za-z0-9]{1}[A-Za-z0-9_.-]*@{1}[A-Za-z0-9_.-]{1,}\.[A-Za-z0-9]{1,}$/
  if (value === '') {
    callback(new Error('メールアドレスを入力して下さい'))
  // メールアドレスが正規表現にマッチする時
  } else if (validEmailRegex.test(value)) {
    callback()
  // メールアドレスが正規表現にマッチしない時
  } else {
    callback(new Error('正しい形式のメールアドレスを入力して下さい'))
  }
}
