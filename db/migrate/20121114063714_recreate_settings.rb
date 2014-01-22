class RecreateSettings < ActiveRecord::Migration
  def up
    create_table :settings do |t|
      t.string :name
      t.string :status
      t.timestamps
    end
  end

  def down
  end
end
