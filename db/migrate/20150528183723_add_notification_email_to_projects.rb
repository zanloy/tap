class AddNotificationEmailToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :notification_email, :string
  end
end
