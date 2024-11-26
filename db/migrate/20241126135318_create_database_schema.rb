class CreateDatabaseSchema < ActiveRecord::Migration[6.1]
  def change
    create_table :appliances do |t|
      t.references :user, null: true, foreign_key: { to_table: :users }
      t.string :name, null: true, limit: 1
      t.text :category, null: true
      t.decimal :wattage, precision: 10, scale: 2, null: true
      t.decimal :total_cost, precision: 10, scale: 2, null: true

      t.timestamps
    end

    create_table :routines do |t|
      t.references :appliance, null: true, foreign_key: true
      t.decimal :cost, precision: 10, scale: 2, null: true
      t.time :starttime, null: true
      t.time :endtime, null: true
      t.string :day, null: true, limit: 255

      t.timestamps
    end

    create_table :recommendations do |t|
      t.references :routine, null: true, foreign_key: true
      t.decimal :cost, precision: 10, scale: 2, null: true
      t.time :starttime, null: true
      t.time :endtime, null: true

      t.timestamps
    end

    create_table :prices do |t|
      t.date :date, null: true
      t.time :starttime, null: true
      t.decimal :price, precision: 10, scale: 2, null: true

      t.timestamps
    end

    create_table :averages do |t|
      t.string :day, null: true, limit: 255
      t.time :time, null: true
      t.integer :average, null: true

      t.timestamps
    end

    create_table :articles do |t|
      t.text :title, null: true
      t.text :content, null: true
      t.text :category, null: true

      t.timestamps
    end
  end
end
