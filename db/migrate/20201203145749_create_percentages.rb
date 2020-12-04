class CreatePercentages < ActiveRecord::Migration[6.0]
  def change
    create_table :percentages do |t|
      t.float :porcentaje
      t.belongs_to :exchange
      t.belongs_to :account
      t.timestamps
    end
  end
end
