require 'rails_helper'

RSpec.describe Pool, type: :model do
  describe 'associations' do
    it { should belong_to(:user) }
    it { should belong_to(:group).optional }
    it { should have_many(:memberships).dependent(:destroy) }
    it { should have_many(:questions).dependent(:destroy) }
    it { should have_many(:members).through(:memberships).source(:user) }
    it { should have_many(:admin_memberships).conditions(role: :admin).class_name('Membership') }
    it { should have_many(:admins).through(:admin_memberships).source(:user) }
    it { should have_many(:participant_memberships).conditions(role: :participant).class_name('Membership') }
    it { should have_many(:participants).through(:participant_memberships).source(:user) }
  end

  describe 'relationship behavior' do
    let(:pool) { create(:pool) }
    let(:user1) { create(:user) }
    let(:user2) { create(:user) }
    let(:user3) { create(:user) }

    before do
      create(:membership, joinable: pool, user: user1, role: :admin)
      create(:membership, joinable: pool, user: user2, role: :participant)
      create(:membership, joinable: pool, user: user3, role: :participant)
    end

    it 'returns all members regardless of role' do
      expect(pool.members).to include(user1, user2, user3)
      expect(pool.members.count).to eq(3)
    end

    it 'returns only admin members' do
      expect(pool.admins).to include(user1)
      expect(pool.admins).not_to include(user2, user3)
      expect(pool.admins.count).to eq(1)
    end

    it 'returns only participant members' do
      expect(pool.participants).to include(user2, user3)
      expect(pool.participants).not_to include(user1)
      expect(pool.participants.count).to eq(2)
    end

    it 'properly destroys dependent memberships' do
      expect { pool.destroy }.to change(Membership, :count).by(-3)
    end
  end

  describe 'validations' do
    subject { build(:pool) }

    it { should validate_presence_of(:name) }
    it { should validate_uniqueness_of(:name).scoped_to(:group_id) }
    it { should validate_numericality_of(:price).is_greater_than_or_equal_to(0) }
  end
end
