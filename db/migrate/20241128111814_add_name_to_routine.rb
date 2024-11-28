class AddNameToRoutine < ActiveRecord::Migration[7.1]
  def change
    add_column :routines, :name, :string
  end
end
