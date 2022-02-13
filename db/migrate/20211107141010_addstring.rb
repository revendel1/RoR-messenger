class Addstring < ActiveRecord::Migration[6.0]
  def change
    change_table :chats do |t|
      t.string :useradd
    end
  end
end
