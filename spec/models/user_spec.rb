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

require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_secure_password }
  it { should validate_presence_of(:email) }
  it { should validate_uniqueness_of(:email) }
end
