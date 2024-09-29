class User < ApplicationRecord
    validates :email, presence: true, uniqueness: true
    has_one :wallet, class_name: :wallet
    has_many :api_keys, as: :bearer

    def authenticate(password)
        self.password == password
    end
end
