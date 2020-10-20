class CreateAccounts < ActiveRecord::Migration[6.0]
  def change
    create_table :accounts do |t|
      t.string :number, unique: true, null: false
      t.integer :balance, null: false
      t.integer :savings, null: false
      t.references :user, null: false, foreign_key: true
      t.timestamps
    end
  end
end
