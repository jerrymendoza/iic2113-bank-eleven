class AddColumnsToExchanges < ActiveRecord::Migration[6.0]
  def change
    add_column :exchanges, :monto, :integer
    add_column :exchanges, :tipo, :string
    add_column :exchanges, :valor_btf, :integer
  end
end
