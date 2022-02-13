class AddUserlist < ActiveRecord::Migration[6.0]
  def change
    change_table :chats do |t|
      t.text :userlist
    end
  end
end
