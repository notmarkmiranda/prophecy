class CreatePools < ActiveRecord::Migration[8.0]
  def change
    create_table :pools do |t|
      t.string :name, null: false
      t.references :user, null: false, foreign_key: true
      t.integer :price, default: 0
      t.boolean :allow_multiple_entries, default: false
      t.datetime :locked_at
      t.datetime :completed_at
      t.references :group, foreign_key: true

      t.timestamps
      t.index [ :name, :group_id ], unique: true
    end
  end
end
