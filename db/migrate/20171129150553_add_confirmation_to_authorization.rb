class AddConfirmationToAuthorization < ActiveRecord::Migration[5.1]
  def change
    add_column :authorizations, :confirmation_token, :string
    add_column :authorizations, :confirmed_at, :datetime
  end
end
