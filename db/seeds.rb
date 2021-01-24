user = User.create!(
  name: "foo",
  email: "foo@bar.com",
  password: "password"
)

30.times do
  FactoryBot.create(:user, :faker_name)
end

10.times do |n|
  user.rooms.create!(
    shop_name: "orion",
    conditions: "engineer only!",
    date: Time.zone.local(2021, 12, 11, 15, 45),
    people_limit: n
  )
end
