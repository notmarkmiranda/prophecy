class Membership < ApplicationRecord
  belongs_to :user
  belongs_to :joinable, polymorphic: true

  enum :role, participant: 0, admin: 1
  enum :status, inactive: 0, active: 1, suspended: 2

  validates :user_id, uniqueness: {
    scope: [ :joinable_type, :joinable_id ], message: "can only have one membership per group or pool"
  }

  def generate_token(expiration = 24.hours.from_now)
    payload = {
      membership_id: id,
      exp: expiration.to_i
    }
    verifier = ActiveSupport::MessageVerifier.new(Rails.application.secret_key_base, digest: "SHA256")
    verifier.generate(payload, purpose: :membership_verification)
  end

  def self.verify_token(token)
    verifier = ActiveSupport::MessageVerifier.new(Rails.application.secret_key_base, digest: "SHA256")
    begin
      data = verifier.verify(token, purpose: :membership_verification)&.symbolize_keys
      return nil unless data.is_a?(Hash) && data[:membership_id] && data[:exp]
      return nil if data[:exp] < Time.now.to_i

      find_by(id: data[:membership_id])
    rescue ActiveSupport::MessageVerifier::InvalidSignature
      nil
    end
  end
end
