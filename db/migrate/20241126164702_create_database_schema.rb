class CreateDatabaseSchema < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :username, :string, null: false
    add_index :users, :username, unique: true

    create_table :appliances do |t|
      t.references :user, null: true, foreign_key: { to_table: :users }
      t.string :name
      t.text :category, null: true
      t.decimal :wattage, precision: 10, scale: 4

      t.timestamps
    end

    create_table :routines do |t|
      t.references :appliance, null: true, foreign_key: true
      t.decimal :cost, precision: 10, scale: 4, null: true
      t.datetime :starttime, null: true
      t.datetime :endtime, null: true
      t.string :day

      t.timestamps
    end

    create_table :recommendations do |t|
      t.references :routine, null: true, foreign_key: true
      t.decimal :cost, precision: 10, scale: 4
      t.time :starttime, null: true
      t.time :endtime, null: true

      t.timestamps
    end

    create_table :prices do |t|
      t.datetime :datetime
      t.decimal :cost, precision: 10, scale: 4

      t.timestamps
    end

    create_table :averages do |t|
      t.string :day
      t.datetime :time
      t.decimal :average

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
