class Subscription < ActiveRecord::Base
  belongs_to :ticket, counter_cache: true
  belongs_to :user
end
