class AddCorrectOptionToQuestions < ActiveRecord::Migration[8.0]
  def change
    add_column :questions, :correct_option_id, :bigint
    add_foreign_key :questions, :options, column: :correct_option_id, on_delete: :nullify
  end
end
