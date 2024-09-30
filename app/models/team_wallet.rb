class TeamWallet < Wallet
  belongs_to :owner, class_name: "Team", foreign_key: :owner_id
end
