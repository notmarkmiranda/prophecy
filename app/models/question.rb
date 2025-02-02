class Question < ApplicationRecord
  belongs_to :pool
  has_many :options, dependent: :destroy

  belongs_to :correct_option, class_name: "Option", optional: true

  validates :text, presence: true
end
