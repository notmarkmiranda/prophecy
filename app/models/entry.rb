class Entry < ApplicationRecord
  belongs_to :user
  belongs_to :pool

  validates :user_id, uniqueness: { scope: :pool_id, message: "can only have one entry per pool" }, unless: -> { pool.allow_multiple_entries? }

  def submit!
    return if submitted_at.present?

    update!(submitted_at: Time.current)
  end

  def paid!
    update!(paid: true)
  end
end
