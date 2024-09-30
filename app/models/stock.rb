class Stock < ApplicationRecord
    validates :amount, numericality: { greater_than_or_equal_to: 0 }
    validates :price, numericality: { greater_than_or_equal_to: 0 }
    belongs_to :owner, class_name: "User", foreign_key: :owner_id
end
