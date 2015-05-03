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

class User < ActiveRecord::Base
  has_secure_password
  validates :email, presence: true, uniqueness: true

  def authenticate(password)
    authorized = super(password)
    if authorized && self.auth_token.nil?
      self.auth_token = SecureRandom.urlsafe_base64
      self.save
    end
    authorized
  end

  def sign_out
    self.auth_token = nil
    self.save
  end

  def as_json(opts)
    opts[:except] ||= :password_digest
    super
  end

end
