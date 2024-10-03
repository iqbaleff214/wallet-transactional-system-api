class Transfer < Transaction
  validate :wallet_present

  private

  def wallet_present
    errors.add(:target_wallet, "must not nil for transfer") unless target_wallet.present?
    errors.add(:source_wallet, "must not nil for transfer") unless source_wallet.present?
  end
end
