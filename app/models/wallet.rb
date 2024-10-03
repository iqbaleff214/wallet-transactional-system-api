class Wallet < ApplicationRecord
  belongs_to :walletable, polymorphic: true
  has_many :transactions_as_source, class_name: 'Transaction', foreign_key: 'source_wallet_id'
  has_many :transactions_as_target, class_name: 'Transaction', foreign_key: 'target_wallet_id'

  def balance
    total = transactions_as_target.sum(:amount) - transactions_as_source.sum(:amount)
    total.to_i
  end
end
