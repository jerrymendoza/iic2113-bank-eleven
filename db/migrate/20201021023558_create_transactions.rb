class CreateTransactions < ActiveRecord::Migration[6.0]
  def change
    create_table :transactions do |t|
      t.integer :amount
      t.datetime :date
      t.integer :transaction_type
      t.integer :balance
      t.boolean :state
      t.integer :confirmation_code
      t.references :account, null: false, foreign_key: true

      t.timestamps
    end
  end
end
