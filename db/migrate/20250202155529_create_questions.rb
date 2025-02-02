class CreateQuestions < ActiveRecord::Migration[8.0]
  def change
    create_table :questions do |t|
      t.references :pool, null: false, foreign_key: true
      t.string :text, null: false

      t.timestamps
    end
  end
end
