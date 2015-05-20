class CreatePurchases < ActiveRecord::Migration
  def change
    create_table :purchases do |t|
      t.belongs_to :ticket, index: true, foreign_key: true
      t.string :name
      t.integer :quantity, default: 1
      t.float :cost, default: 0.0
      t.string :url

      t.timestamps null: false
    end
  end
end
