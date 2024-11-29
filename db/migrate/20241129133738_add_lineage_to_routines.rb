class AddLineageToRoutines < ActiveRecord::Migration[7.1]
  def change
    add_column :routines, :lineage, :integer
  end
end
