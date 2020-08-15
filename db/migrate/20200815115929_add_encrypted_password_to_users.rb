class AddEncryptedPasswordToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :encrypted_password, :text, null: false
  end
end
