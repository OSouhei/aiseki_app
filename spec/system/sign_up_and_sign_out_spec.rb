require "rails_helper"

RSpec.describe "Sign up and sign out", type: :system do
  let(:user) { build(:user) }

  before do
    ActionController::Base.allow_forgery_protection = true
  end

  after do
    ActionController::Base.allow_forgery_protection = false
  end

  scenario "sign up page has correct title" do
    visit "/#/sign_up"
    expect(page).to have_title "アカウント登録 | 相席アプリ"
  end

  scenario "sign in and sign out" do
    expect {
      visit "/#/sign_up"
      fill_in id: "name", with: user.name
      fill_in id: "email", with: user.email
      fill_in id: "password", with: user.password
      fill_in id: "password-confirmation", with: user.password
      click_button "登録"
      expect(page).to have_title "#{user.name} | 相席アプリ"
      expect(page).to have_content "アカウントを登録しました" # flash
    }.to change(User, :count).by(1)
    # ユーザー個別ページに遷移しているか？
    expect(page).to have_content user.id
    expect(page).to have_content user.name
    expect(page).to have_content user.email
    # ユーザーがログインしているか？
    expect(page).to have_content "アカウント情報"
    expect(page).to have_content "ログアウト"
    expect(page).to_not have_content "ログイン"
    expect(page).to_not have_content "新規登録"
    expect(page).to have_button "退会"
    # ここからサインアウトのテスト
    # confirmダイアログでキャンセルを押した場合は退会もキャンセルされる
    expect {
      page.dismiss_confirm do
        click_button "退会"
      end
      expect(page).to have_title "#{user.name} | 相席アプリ"
    }.to_not change(User, :count)
    # confirmダイアログでokした場合は退会
    expect {
      page.accept_confirm do
        click_button "退会"
      end
      expect(page).to have_content "退会しました" # flash
      expect(page).to have_title "相席アプリ"
    }.to change(User, :count).by(-1)
  end

  scenario "form display validation message" do
    visit "/#/sign_up"
    fill_in id: "name", with: ""
    fill_in id: "email", with: ""
    fill_in id: "password", with: ""
    fill_in id: "password-confirmation", with: ""
    fill_in id: "name", with: "" # フォーカスが外れたときにバリデーションされるため
    # フロントのバリデーション
    expect(page).to have_content "名前を入力して下さい"
    expect(page).to have_content "メールアドレスを入力して下さい"
    expect(page).to have_content "パスワードを入力して下さい"
    expect(page).to have_content "パスワード（確認）を入力して下さい"
    expect {
      click_button "登録"
      expect(page).to have_title "アカウント登録 | 相席アプリ" # Ajax終了を待つ
    }.to_not change(User, :count)
    # バックエンドのエラーメッセージが表示されるか？
    expect(page).to have_content "メールアドレスが入力されていません"
    expect(page).to have_content "パスワードが入力されていません"
    expect(page).to have_content "名前が入力されていません"
    # メールアドレスが既に使用されている場合のエラーメッセージ
    user.save
    fill_in id: "email", with: user.email
    fill_in id: "name", with: ""
    expect {
      click_button "登録"
      expect(page).to have_title "アカウント登録 | 相席アプリ" # Ajax終了を待つ
    }.to_not change(User, :count)
    expect(page).to have_content "メールアドレスすでに使用されています"
    # パスワードとパスワード（確認）が一致しない場合のエラーメッセージ
    fill_in id: "password", with: "foobar"
    fill_in id: "password-confirmation", with: "password"
    fill_in id: "name", with: ""
    expect(page).to have_content "パスワードと一致していません"
  end
end
