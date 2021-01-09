require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { FactoryBot.build(:user) }

  it "has valid factory" do
    expect(user).to be_valid
  end

  it "is invalid without name" do
    user.name = "   "
    user.valid?
    expect(user.errors[:name]).to include("can't be blank")
  end

  it "is invalid with more than 50 chars name" do
    user.name = "a" * 51
    user.valid?
    expect(user.errors[:name]).to include("is too long (maximum is 50 characters)")
  end

  it "is invalid without email" do
    user.email = "   "
    user.valid?
    expect(user.errors[:email]).to include("can't be blank")
  end

  it "is invalid with more than 255 chars email" do
    user.email = "a" * 244 + "@example.com"
  end

  it "is invalid with invalid adress" do
    invalid_addresses = %w[user@example,com user_at_foo.org user.name@example. foo@bar_baz.com foo@bar+baz.com]
    invalid_addresses.each do |invalid_address|
      user.email = invalid_address
      user.valid?
      expect(user).to be_invalid
    end
  end

  it "is invalid with dulicate email" do
    user = FactoryBot.create(:user)
    duplicate_user = FactoryBot.build(:user, email: user.email)
    duplicate_user.valid?
    expect(duplicate_user.errors[:email]).to include("has already been taken")
  end

  it "is invalid without password" do
    user.password = "   "
    user.valid?
    expect(user.errors[:password]).to include("can't be blank")
  end
end
