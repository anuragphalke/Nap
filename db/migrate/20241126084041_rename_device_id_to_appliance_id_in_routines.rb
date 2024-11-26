class RenameDeviceIdToApplianceIdInRoutines < ActiveRecord::Migration[7.1]
  def change
    rename_column :routines, :device_id, :appliance_id
  end
end
