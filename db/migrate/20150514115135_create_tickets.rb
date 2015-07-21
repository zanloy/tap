class CreateTickets < ActiveRecord::Migration
  def change
    create_table :tickets do |t|
      t.belongs_to :project, index: true, foreign_key: true, null: false
      t.belongs_to :reporter, class_name: :user, index: true, null: false
      t.belongs_to :assignee, class_name: :user, index: true
      t.string :state, default: :unassigned
      t.integer :priority, default: 1
      t.string :title, null: false
      t.text :description
      t.integer :purchases_count, default: 0
      t.integer :comments_count, default: 0
      t.belongs_to :closed_by, class_name: :user
      t.datetime :closed_at
      t.belongs_to :approving_manager, class_name: :user
      t.datetime :manager_approved_at
      t.belongs_to :approving_executive, class_name: :user
      t.datetime :executive_approved_at

      t.timestamps null: false
    end
  end
end
