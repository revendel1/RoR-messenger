class ChangeOurTable < ActiveRecord::Migration[6.0]
  def change
    change_table :users do |t|
      t.string :password_digest
    end
  end
end
