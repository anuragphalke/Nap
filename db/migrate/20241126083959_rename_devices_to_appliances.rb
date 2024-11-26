class RenameDevicesToAppliances < ActiveRecord::Migration[7.1]
  def change
    rename_table :devices, :appliances
  end
end
