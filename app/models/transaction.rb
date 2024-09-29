class Transaction < ApplicationRecord
    validates :amount, numericality: { greater_than: 0 }
    validates :to_wallet_id, numericality: { other_than: :from_wallet_id}
end
