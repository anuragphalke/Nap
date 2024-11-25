class CreateRecommendations < ActiveRecord::Migration[7.1]
  def change
    create_table :recommendations do |t|
      t.references :routine, null: false, foreign_key: true
      t.float :cost
      t.text :content
      t.time :starttime
      t.time :endtime

      t.timestamps
    end
  end
end
