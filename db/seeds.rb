user = User.create!(
  name: "foo",
  email: "foo@bar.com",
  password: "password"
)

10.times do |n|
  user.rooms.create!(
    shop_name: "orion",
    conditions: "engineer only!",
    date: Time.zone.local(2021, 12, 11, 15, 45),
    people_limit: n
  )
end

room = Room.first
30.times do |n|
  user = User.create!(
    name: Faker::Name.name,
    email: "sampleuser-#{n}@example.com",
    password: "password"
  )
  user.join room
end

