class CreateSchedules < ActiveRecord::Migration
  def change
    create_table :schedules do |t|
      t.integer :exam_id
      t.datetime :sh_date
      t.string :created_by
      t.string :updated_by
      t.boolead :remote, default: false
      t.timestamps
    end
  end
end
