class Subscription < ActiveRecord::Base
  belongs_to :ticket
  belongs_to :user
end
