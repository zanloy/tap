class CreateMemberships < ActiveRecord::Migration
  def change
    create_table :memberships do |t|
      t.belongs_to :project, index: true, foreign_key: true, null: false
      t.belongs_to :user, index: true, foreign_key: true, null: false
      t.string :role, null: false, default: 'member'

      t.timestamps null: false
    end
  end
end
