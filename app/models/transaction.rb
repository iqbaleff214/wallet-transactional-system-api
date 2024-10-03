class Transaction < ApplicationRecord
  belongs_to :source_wallet, class_name: 'Wallet', optional: true
  belongs_to :target_wallet, class_name: 'Wallet', optional: true

  validates :amount, presence: true

  def credit?
    transaction_type == 'credit'
  end

  def debit?
    transaction_type == 'debit'
  end

  def transfer?
    transaction_type == 'transfer'
  end
end
