require 'rails_helper'

RSpec.describe Pool, type: :model do
  it { should belong_to(:super_admin).class_name('User').with_foreign_key('user_id') }
  it { should validate_presence_of(:name) }
  it { should validate_numericality_of(:price).is_greater_than_or_equal_to(0).allow_nil }
end
