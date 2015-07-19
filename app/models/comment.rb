class Comment < ActiveRecord::Base

  # Associations
  belongs_to :ticket, counter_cache: true
  belongs_to :user, counter_cache: true

  # Validation
  validates_presence_of :ticket, :user, :comment

end
