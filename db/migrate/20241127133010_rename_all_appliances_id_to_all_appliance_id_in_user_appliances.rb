class RenameAllAppliancesIdToAllApplianceIdInUserAppliances < ActiveRecord::Migration[7.1]
  def change
    rename_column :user_appliances, :all_appliances_id, :all_appliance_id
  end
end
