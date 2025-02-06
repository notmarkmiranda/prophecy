class Pool < ApplicationRecord
  belongs_to :user
  belongs_to :group, optional: true
  has_many :memberships, as: :joinable, dependent: :destroy
  has_many :members, through: :memberships, source: :user
  has_many :admin_memberships, -> { where(role: :admin) }, as: :joinable, class_name: "Membership"
  has_many :admins, through: :admin_memberships, source: :user
  has_many :participant_memberships, -> { where(role: :participant) }, as: :joinable, class_name: "Membership"
  has_many :participants, through: :participant_memberships, source: :user
  has_many :questions, dependent: :destroy
  has_many :entries, dependent: :destroy

  validates :name, presence: true, uniqueness: { scope: :group_id }
  validates :price, numericality: { greater_than_or_equal_to: 0 }
end
