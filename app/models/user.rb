class User < ApplicationRecord
  validates :email, presence: true, uniqueness: true
  has_many :pools
  has_many :groups

  def authenticate_login_code(login_code)
    login_code == self.login_code && login_code_expires_at > Time.now
  end

  def set_login_code
    self.login_code = (SecureRandom.random_number(9e5) + 1e5).to_i.to_s
    self.login_code_expires_at = Time.now + 15.minutes
    self.save
  end
end
