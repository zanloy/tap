class CreateAttachments < ActiveRecord::Migration
  def change
    create_table :attachments do |t|
      t.belongs_to :ticket, index: true, foreign_key: true
      t.string :name
      t.attachment :file

      t.timestamps null: false
    end
  end
end
