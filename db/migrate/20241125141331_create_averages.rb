class CreateAverages < ActiveRecord::Migration[7.1]
  def change
    create_table :averages do |t|
      t.references :price, null: false, foreign_key: true
      t.date :day
      t.time :time
      t.float :average

      t.timestamps
    end
  end
end
