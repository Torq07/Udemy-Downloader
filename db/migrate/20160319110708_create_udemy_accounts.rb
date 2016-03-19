class CreateUdemyAccounts < ActiveRecord::Migration
  def change
    create_table :udemy_accounts do |t|
      t.text :account_id
      t.string :udemy_username
      t.string :udemy_password

      t.timestamps null: false
    end
  end
end
