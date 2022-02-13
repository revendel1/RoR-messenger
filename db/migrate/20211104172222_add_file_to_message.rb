class AddFileToMessage < ActiveRecord::Migration[6.0]
  def change
    change_table :messages do |t|
      t.string :file
    end
  end
end
