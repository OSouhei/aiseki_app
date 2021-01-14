# expect(user).to valid_password? "foobar" => boolean

RSpec::Matchers.define :valid_password? do |expected|
  match do |actual|
    actual.valid_password?(expected)
  end
end
