class Transaction < ApplicationRecord
    validates :amount, numericality: { greater_than: 0 }
    validates :to_wallet_id, numericality: { other_than: :from_wallet_id }
    validates :to_wallet_id, :from_wallet_id, presence: true, uniqueness: true
end
