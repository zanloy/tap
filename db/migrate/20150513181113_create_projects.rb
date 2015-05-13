class CreateProjects < ActiveRecord::Migration
  def change
    create_table :projects do |t|
      t.string :name
      t.string :description
      t.string :icon
      t.boolean :private, default: false
      t.belongs_to :owner, class_name: :user, index: true
      t.belongs_to :auto_assignee, class_name: :user

      t.timestamps null: false
    end
  end
end
