class CreateEntries < ActiveRecord::Migration[8.0]
  def change
    create_table :entries do |t|
      t.references :user, null: false, foreign_key: true
      t.references :pool, null: false, foreign_key: true
      t.datetime :submitted_at
      t.integer :score, default: 0
      t.boolean :paid, default: false, null: false

      t.timestamps
    end
  end
end
