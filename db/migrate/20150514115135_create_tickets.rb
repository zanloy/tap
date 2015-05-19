class CreateTickets < ActiveRecord::Migration
  def change
    create_table :tickets do |t|
      t.belongs_to :project, index: true, foreign_key: true, null: false
      t.belongs_to :reporter, class_name: :user, index: true, null: false
      t.belongs_to :assignee, class_name: :user, index: true
      t.boolean :closed, default: false
      t.boolean :archived, default: false
      t.integer :priority, default: 1
      t.string :title, null: false
      t.text :description

      t.timestamps null: false
    end
  end
end
