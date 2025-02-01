class Membership < ApplicationRecord
  belongs_to :user
  belongs_to :joinable, polymorphic: true

  enum :role, participant: 0, admin: 1

  validates :user_id, uniqueness: {
    scope: [ :joinable_type, :joinable_id ], message: "can only have one membership per group or pool"
  }
end
