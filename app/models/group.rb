class Group < ApplicationRecord
  belongs_to :user
  has_many :pools, dependent: :destroy

  validates :name, presence: true, uniqueness: true
end
