class Debit < Transaction
  validate :target_wallet_present

  private

  def target_wallet_present
    errors.add(:target_wallet, "must be nil for debits") if target_wallet.present?
  end
end
