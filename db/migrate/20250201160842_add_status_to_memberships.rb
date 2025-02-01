class AddStatusToMemberships < ActiveRecord::Migration[8.0]
  def change
    add_column :memberships, :status, :integer, default: 0, null: false
  end
end
