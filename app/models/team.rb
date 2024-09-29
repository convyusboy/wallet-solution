class Team < ApplicationRecord
    has_one :leader, class_name: "User"
end
