class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class

  def wallet_id
    wallet&.id
  end

  def create_wallet
    Wallet.create(walletable: self)
  end
end
