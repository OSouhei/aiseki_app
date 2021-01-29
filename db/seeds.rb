user = User.create!(
  name: "foo",
  email: "foo@bar.com",
  password: "password"
)


user.rooms.create!(
  title: "Sample Room",
  content: "Engineer only.",
  shop_name: "orion",
  limit: 5
)

10.times do
  user.rooms.create!(
    title: Faker::Lorem.word,
    content: Faker::Lorem.paragraph(sentence_count: 3),
    shop_name: Faker::Restaurant.name,
    limit: Faker::Number.non_zero_digit
  )
end

room = Room.first

4.times do |n|
  user = User.create!(
    name: Faker::Name.name,
    email: "sample-#{n}@example.com",
    password: "password"
  )
  user.join room
end

100.times do |n|
  user = User.create!(
    name: Faker::Name.name,
    email: "example-#{n}@example.com",
    password: "password"
  )
  user.rooms.create!(
    title: Faker::Lorem.word,
    content: Faker::Lorem.paragraph(sentence_count: 3),
    shop_name: Faker::Restaurant.name,
    limit: Faker::Number.non_zero_digit
  )
end
