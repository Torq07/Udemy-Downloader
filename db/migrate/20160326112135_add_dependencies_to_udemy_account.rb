class AddDependenciesToUdemyAccount < ActiveRecord::Migration
  def change
  	remove_column :udemy_accounts, :account_id
  	add_reference :udemy_accounts, :user, index: true
  end
end
