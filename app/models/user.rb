class User < ApplicationRecord
    PASSWORD_FORMAT = /\A
        (?=.{8,})          # Must contain 8 or more characters
    /x
    validates :email, presence: true, uniqueness: true
    validates :password, presence: true,
        format: { with: PASSWORD_FORMAT }
    has_one :wallet, class_name: "Wallet", foreign_key: :owner_id
    has_one :stock, class_name: "Stock", foreign_key: :owner_id
    has_many :api_keys, as: :bearer
    after_create :create_wallet, :create_stock

    def authenticate(password)
        self.password == password
    end

    def create_wallet
        Wallet.create!(owner: self, amount: 1000000, wallet_type: "User")
    end

    def create_stock
        Stock.create!(owner: self, amount: 1, price: 500000)
    end
end
