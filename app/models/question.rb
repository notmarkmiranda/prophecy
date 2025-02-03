class Question < ApplicationRecord
  belongs_to :pool
  has_many :options, dependent: :destroy

  belongs_to :correct_option, class_name: "Option", optional: true

  validates :text, presence: true

  accepts_nested_attributes_for :options, reject_if: :all_blank

  scope :persisted, -> { where.not(id: nil) }
end
