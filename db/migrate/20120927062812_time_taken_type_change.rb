class TimeTakenTypeChange < ActiveRecord::Migration
  def up
   connection.execute(%q{
    alter table answers
    alter column time_taken
    type integer using cast(time_taken as integer)
  })
  end

  def down
  end
end
