class Wallet < ApplicationRecord
    belongs_to :owner, class_name: "User", foreign_key: :owner_id
    belongs_to :owner, class_name: "Team", foreign_key: :owner_id

    validates :amount, numericality: { greater_than_or_equal_to: 0 }
end
