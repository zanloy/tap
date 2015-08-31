class AddAttachmentsCountToTicket < ActiveRecord::Migration
  def change
    add_column :tickets, :attachments_count, :integer, default: 0
  end
end
