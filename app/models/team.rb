class Team < ApplicationRecord
    has_one :leader, class_name: "User", foreign_key: :leader_id
    after_create :create_wallet

    def create_wallet
        Wallet.create!(owner: self, amount: 1000000, wallet_type: "Team")
    end
end
