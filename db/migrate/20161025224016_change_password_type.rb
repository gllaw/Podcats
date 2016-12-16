class ChangePasswordType < ActiveRecord::Migration
  def change
  	rename_column :admins, :password_digest, :password
  end
end
