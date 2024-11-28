class AddNicknameToUserAppliance < ActiveRecord::Migration[7.1]
  def change
    add_column :user_appliances, :nickname, :string
  end
end
