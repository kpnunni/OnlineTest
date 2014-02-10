class Addschedule < ActiveRecord::Migration
  def change
    add_column :schedules, :client_id, :integer
  end
end
