class Pool < ApplicationRecord
  belongs_to :super_admin, class_name: "User", foreign_key: "user_id"
  validates :name, presence: true
  validates :price, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true
end
