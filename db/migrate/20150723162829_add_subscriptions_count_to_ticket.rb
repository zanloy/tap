class AddSubscriptionsCountToTicket < ActiveRecord::Migration
  def change
    add_column :tickets, :subscriptions_count, :integer, default: 0
  end
end
