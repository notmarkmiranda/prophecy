class UpdateMembershipsToBePolymorphic < ActiveRecord::Migration[8.0]
  def change
    # remove the group_id column
    remove_index :memberships, column: [ :user_id, :group_id ], if_exists: true
    remove_index :memberships, column: :group_id, if_exists: true
    remove_column :memberships, :group_id, if_exists: true

    # add polymorphic joinable references
    add_reference :memberships, :joinable, polymorphic: true, null: false

    # add unique index to prevent duplicate memberships for the same joinable
    add_index :memberships, [ :user_id, :joinable_type, :joinable_id ], unique: true, name: "index_memberships_on_user_and_joinable"
  end
end
