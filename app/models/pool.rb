class Pool < ApplicationRecord
  belongs_to :user
  belongs_to :group, optional: true

  validates :name, presence: true, uniqueness: { scope: :group_id }
  validates :price, numericality: { greater_than_or_equal_to: 0 }
end
