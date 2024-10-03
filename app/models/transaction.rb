class Transaction < ApplicationRecord
  belongs_to :source_wallet, class_name: 'Wallet', optional: true
  belongs_to :target_wallet, class_name: 'Wallet', optional: true

  validates :amount, presence: true
  validate :validate_transaction_type

  def validate_transaction_type
    if credit? && source_wallet.present?
      errors.add(:source_wallet, 'must be nil for credit transactions')
    elsif debit? && target_wallet.present?
      errors.add(:target_wallet, 'must be nil for debit transactions')
    end
  end

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
