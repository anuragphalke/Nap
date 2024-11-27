class UpdateAppliancesSchema < ActiveRecord::Migration[7.1]
  def change
    # Rename appliances table to user_appliances
    rename_table :appliances, :user_appliances

    # Remove unnecessary columns
    remove_column :user_appliances, :name, :string
    remove_column :user_appliances, :category, :text
    remove_column :user_appliances, :wattage, :decimal

    # Create the all_appliances table
    create_table :all_appliances do |t|
      t.text :category
      t.text :subcategory
      t.text :brand
      t.text :model
      t.decimal :wattage, precision: 10, scale: 4
      t.timestamps
    end


  end
end
