class AddAccountNumberToTransaction < ActiveRecord::Migration[6.0]
  def change
    add_column :transactions, :account_number, :string
  end
end
