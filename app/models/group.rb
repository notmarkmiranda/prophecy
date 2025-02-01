class Group < ApplicationRecord
  belongs_to :user
  has_many :pools, dependent: :destroy
  has_many :memberships, as: :joinable, dependent: :destroy

  validates :name, presence: true, uniqueness: true
end
