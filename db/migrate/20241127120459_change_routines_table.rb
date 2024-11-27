class ChangeRoutinesTable < ActiveRecord::Migration[7.1]
  def change
    remove_column :routines, :appliance_id


     # Add the new foreign key column first
     add_column :routines, :user_appliance_id, :bigint

     # Add foreign key to link routines to user_appliance
     add_foreign_key :routines, :user_appliances, column: :user_appliance_id
  end
end
