require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many(:created_pools).class_name('Pool').with_foreign_key('user_id').dependent(:destroy) }
end
