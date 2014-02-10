class Addingclientrelations < ActiveRecord::Migration
  def change
    add_column :templates, :client_id, :integer
    add_column :settings, :client_id, :integer
    add_column :categories, :client_id, :integer
    add_column :questions, :client_id, :integer
    add_column :instructions, :client_id, :integer
    add_column :exams, :client_id, :integer
    add_column :candidates, :client_id, :integer
  end
end
