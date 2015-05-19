class CreateProjects < ActiveRecord::Migration
  def change
    create_table :projects do |t|
      t.string :name
      t.string :description
      t.string :icon
      t.boolean :private, default: false
      t.belongs_to :auto_assignee, class_name: :user
      t.boolean :show_in_navbar, default: false

      t.timestamps null: false
    end
  end
end
