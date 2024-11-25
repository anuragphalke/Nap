class CreateDevices < ActiveRecord::Migration[7.1]
  def change
    create_table :devices do |t|
      t.references :user, null: false, foreign_key: true
      t.string :name
      t.string :category
      t.boolean :state
      t.float :total_cost

      t.timestamps
    end
  end
end
