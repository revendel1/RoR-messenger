class Forbidnull < ActiveRecord::Migration[6.0]
  def change
    change_column :chats, :name, :string, null: false
    change_column :users, :login, :string, null: false
  end
end
