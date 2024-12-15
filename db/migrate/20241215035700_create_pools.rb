class CreatePools < ActiveRecord::Migration[8.0]
  def change
    create_table :pools do |t|
      t.string :name, null: false
      t.decimal :price, precision: 10, scale: 2
      t.boolean :allow_multiple_entries, default: false
      t.datetime :locked_at
      t.datetime :completed_at

      t.timestamps
    end
  end
end
