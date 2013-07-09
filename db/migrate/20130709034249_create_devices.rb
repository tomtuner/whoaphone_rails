class CreateDevices < ActiveRecord::Migration
  def change
    create_table :devices do |t|
      t.string :token
      t.string :ph_num

      t.timestamps
    end
  end
end
