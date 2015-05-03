# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  email           :string
#  password_digest :string
#  auth_token      :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

FactoryGirl.define do
  factory :user do
    email { Faker::Internet.email }
    password "password"
    factory :user_signed_in do
      auth_token { SecureRandom.urlsafe_base64 }
    end
    factory :user_not_signed_in do
      auth_token nil
    end
  end

end
