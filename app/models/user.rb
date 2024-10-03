class User < ApplicationRecord
  has_secure_password

  has_one :wallet, as: :walletable

  after_create :create_wallet

  validates :email, presence: true, uniqueness: true

  def generate_auth_token
    loop do
      self.auth_token = SecureRandom.hex(10)
      break unless User.exists?(auth_token: auth_token)
    end
    save!
    auth_token
  end
end
