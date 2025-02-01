require 'rails_helper'

RSpec.describe Membership, type: :model do
  let(:membership) { create(:membership) }

  describe '#generate_token' do
    it 'generates a token with an expiration' do
      token = membership.generate_token
      expect(token).not_to be_nil
    end
  end

  describe '.verify_token' do
    context 'with a valid token' do
      it 'returns the membership' do
        token = membership.generate_token(1.hour.from_now)
        verified_membership = described_class.verify_token(token)
        expect(verified_membership).to eq(membership)
      end
    end

    context 'with an expired token' do
      it 'returns nil' do
        token = membership.generate_token(1.minute.ago)
        verified_membership = described_class.verify_token(token)
        expect(verified_membership).to be_nil
      end
    end

    context 'with an invalid token' do
      it 'returns nil' do
        verified_membership = described_class.verify_token('invalid_token')
        expect(verified_membership).to be_nil
      end
    end
  end
end
