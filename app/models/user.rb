class User < ApplicationRecord
    validates :email, presence: true, uniqueness: true
    has_one :wallet, class_name: :wallet
end
