class Credit < Transaction
  validate :source_wallet_present

  private

  def source_wallet_present
    errors.add(:source_wallet, "must be nil for credits") if source_wallet.present?
  end
end
