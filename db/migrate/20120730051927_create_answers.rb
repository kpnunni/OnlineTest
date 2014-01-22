class CreateAnswers < ActiveRecord::Migration
  def change
    create_table :answers do |t|
      t.integer :candidate_id
      t.integer :question_id
      t.string :answer
      t.integer :time_taken
      t.timestamps
    end
  end
end
