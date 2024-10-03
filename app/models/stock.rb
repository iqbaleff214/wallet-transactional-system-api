class Stock < ApplicationRecord

  has_one :wallet, as: :walletable

  after_create :create_wallet
end
