class AddRoutineIdToArticles < ActiveRecord::Migration[7.1]
  def change
    add_reference :articles, :user_appliance, foreign_key: true
    rename_column :articles, :category, :subcategory
  end
end
