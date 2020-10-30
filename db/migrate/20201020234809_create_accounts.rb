class CreateAccounts < ActiveRecord::Migration[6.0]
  def change
    create_table :accounts do |t|
      t.string :number
      t.integer :balance
      t.integer :account_type
      t.references :user, null: false, foreign_key: true
      t.timestamps
    end
  end
end
