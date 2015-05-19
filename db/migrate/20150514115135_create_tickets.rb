class CreateTickets < ActiveRecord::Migration
  def change
    create_table :tickets do |t|
      t.belongs_to :project, index: true, foreign_key: true, null: false
      t.belongs_to :submitter, class_name: :user, index: true, null: false
      t.belongs_to :assignee, class_name: :user, index: true
      #t.string :status, default: 'submitted', index: true
      t.boolean :resolved, default: false
      t.boolean :archived, default: false
      t.integer :priority, default: 1
      t.string :title, null: false
      t.text :description

      t.timestamps null: false
    end
  end
end
