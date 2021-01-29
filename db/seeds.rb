user = User.create!(
  name: "foo",
  email: "foo@bar.com",
  password: "password"
)

10.times do |n|
  user.rooms.create!(
    title: "Sample Room",
    content: "This is sample room.",
    shop_name: "orion",
    limit: 5
  )
end

room = Room.first

4.times do |n|
  user = User.create!(
    name: Faker::Name.name,
    email: "sampleuser-#{n}@example.com",
    password: "password"
  )
  user.join room
end
