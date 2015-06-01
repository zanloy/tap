class AddLockedToTicket < ActiveRecord::Migration
  def change
    add_column :tickets, :locked, :boolean, default: false
  end
end
