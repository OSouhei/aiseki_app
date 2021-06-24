RSpec::Matchers.define :be_user_signed_in do
  match do |actual|
    return actual.user_signed_in?
  end
end
