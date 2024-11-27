class AddForeignKeyToUserAppliances < ActiveRecord::Migration[7.1]
  def change
    # Add the new foreign key column first
    add_column :user_appliances, :all_appliances_id, :bigint

    # Add foreign key to link user_appliances to all_appliances
    add_foreign_key :user_appliances, :all_appliances, column: :all_appliances_id
  end
end
