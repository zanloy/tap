class AddCountersToTicket < ActiveRecord::Migration
  def change
    add_column :tickets, :purchases_count, :integer
    add_column :tickets, :comments_count, :integer
  end
end
