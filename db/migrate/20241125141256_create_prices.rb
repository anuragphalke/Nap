class CreatePrices < ActiveRecord::Migration[7.1]
  def change
    create_table :prices do |t|
      t.date :date
      t.float :hour00
      t.float :hour01
      t.float :hour02
      t.float :hour03
      t.float :hour04
      t.float :hour05
      t.float :hour06
      t.float :hour07
      t.float :hour08
      t.float :hour09
      t.float :hour10
      t.float :hour11
      t.float :hour12
      t.float :hour13
      t.float :hour14
      t.float :hour15
      t.float :hour16
      t.float :hour17
      t.float :hour18
      t.float :hour19
      t.float :hour20
      t.float :hour21
      t.float :hour22
      t.float :hour23

      t.timestamps
    end
  end
end
