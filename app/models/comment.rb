class Comment < ActiveRecord::Base

  # Associations
  belongs_to :ticket
  belongs_to :user

  # Validation
  validates_presence_of :ticket, :user, :comment

end
