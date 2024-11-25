class CreateRoutines < ActiveRecord::Migration[7.1]
  def change
    create_table :routines do |t|
      t.references :device, null: false, foreign_key: true
      t.float :cost
      t.time :starttime
      t.time :endtime
      t.date :day

      t.timestamps
    end
  end
end
